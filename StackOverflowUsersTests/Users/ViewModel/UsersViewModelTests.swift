import Foundation
import Testing
@testable import StackOverflowUsers
@testable import StackOverflowService

@MainActor
struct UsersViewModelTests {

    private let stubbedUsersUseCase = SpyUsersUseCase()
    private let stubbedUserSelectedDelegate = StubUserSelectedDelegate()
    private var usersViewModel: UsersViewModel!

    init() {
        usersViewModel = UsersViewModel(
            usersUseCase: stubbedUsersUseCase,
            userSelectedDelegate: stubbedUserSelectedDelegate
        )
    }

    @Test("Screen title is correct")
    func screenTitle() throws {
        #expect(
            usersViewModel.screenTitle == UsersViewModel.Strings.screenTitle
        )
    }

    @Test("When loadData is called then users are fetched successfully")
    func loadDataIsSuccessful() async throws {

        stubbedUsersUseCase.stubbedUsers = [
            UserViewModel(
                id: 1,
                name: "displayName",
                reputation: 44,
                profileImageURL: URL(string: "https://example.com/image.png"),
                location: "Manchester",
                websiteURL: "https://websiteUrl.com",
                followed: false
            )
        ]

        var invokedOnUsersFetched = false
        usersViewModel.onUsersFetched = {
            invokedOnUsersFetched = true
        }

        var invokedOnError = false
        usersViewModel.onError = { _, _, _ in
            invokedOnError = true
        }

        usersViewModel.loadData()
        await usersViewModel.loadDataTask?.value

        #expect(invokedOnUsersFetched)
        #expect(invokedOnError == false)
        let users = usersViewModel.users
        #expect(users.count == 1)
        let firstUser = try #require(users.first)
        #expect(firstUser.name == "displayName")
        #expect(firstUser.id == 1)
        #expect(firstUser.reputation == 44)
        #expect(firstUser.location == "Manchester")
        #expect(firstUser.websiteURL == "https://websiteUrl.com")

        let expectedUrl = try #require(URL(string: "https://example.com/image.png"))
        #expect(firstUser.profileImageURL == expectedUrl)
    }

    @Test("When loadData is called and error occurs then error message is present")
    func loadDataFails() async throws {

        stubbedUsersUseCase.stubbedError = MockError.mock

        var invokedOnUsersFetched = false
        usersViewModel.onUsersFetched = {
            invokedOnUsersFetched = true
        }

        var errorTitle = ""
        var errorMessage = ""
        var errorButtonText = ""
        usersViewModel.onError = { title, message, buttonText in
            errorTitle = title
            errorMessage = message
            errorButtonText = buttonText
        }

        usersViewModel.loadData()
        await usersViewModel.loadDataTask?.value

        #expect(invokedOnUsersFetched == false)
        let users = usersViewModel.users
        #expect(users.count == 0)

        #expect(errorTitle == UsersViewModel.Strings.errorMessageTitle)
        #expect(errorMessage == UsersViewModel.Strings.errorFetchingUsers)
        #expect(errorButtonText == UsersViewModel.Strings.errorMessageButtonTitle)
    }

    @Test("When toggleFollowing is called then use case is invoked and index is emitted")
    func toggleFollowingCallsUseCaseAndEmitsIndex() async throws {

        let user = UserViewModel(
            id: 1,
            name: "displayName",
            reputation: 44,
            profileImageURL: URL(string: "https://example.com/image.png"),
            location: "Manchester",
            websiteURL: "https://websiteUrl.com",
            followed: false
        )
        stubbedUsersUseCase.stubbedUsers = [user]

        var receivedIndex: Int?
        usersViewModel.onUserUpdated = { index in
            receivedIndex = index
        }

        usersViewModel.loadData()
        await usersViewModel.loadDataTask?.value

        usersViewModel.toggleFollowing(of: user)

        #expect(stubbedUsersUseCase.invokedToggleFollowing)
        #expect(
            stubbedUsersUseCase.invokedToggleFollowingParameters?.user.id == user.id
        )
        #expect(receivedIndex == 0)
        #expect(stubbedUsersUseCase.invokedFollowing)
    }

    @Test("When user is tapped, then user selected delegate is called")
    func tappingUserCallsDelegate() async throws {
        let user = UserViewModel(
            id: 1,
            name: "displayName",
            reputation: 44,
            profileImageURL: URL(string: "https://example.com/image.png"),
            location: "Manchester",
            websiteURL: "https://websiteUrl.com",
            followed: false
        )

        #expect(stubbedUserSelectedDelegate.invokedWithUser == nil)
        usersViewModel.tapped(user: user)
        #expect(stubbedUserSelectedDelegate.invokedWithUser == user)
    }
}

final class StubUserSelectedDelegate: UserSelectedDelegate {
    var invokedWithUser: UserViewModel?

    func didSelectUser(_ user: UserViewModel) {
        invokedWithUser = user
    }
}
