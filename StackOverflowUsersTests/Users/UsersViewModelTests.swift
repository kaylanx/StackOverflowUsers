import Foundation
import Testing
@testable import StackOverflowUsers
@testable import StackOverflowService

@MainActor
struct UsersViewModelTests {

    private let stubbedUserService = SpyUserService()
    private var usersViewModel: UsersViewModel!

    init() {
        usersViewModel = UsersViewModel(userService: stubbedUserService)
    }

    @Test("Screen title is correct")
    func screenTitle() throws {
        #expect(
            usersViewModel.screenTitle == UsersViewModel.Strings.screenTitle
        )
    }

    @Test("When loadData is called then users are fetched successfully")
    func loadDataIsSuccessful() async throws {

        stubbedUserService.stubbedUsers = [
            User.mock
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

        let expectedUrl = try #require(URL(string: "https://example.com/image.png"))
        #expect(firstUser.profileImageURL == expectedUrl)
    }

    @Test("When loadData is called and error occurs then error message is present")
    func loadDataFails() async throws {

        stubbedUserService.stubbedError = MockError.mock

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
}

