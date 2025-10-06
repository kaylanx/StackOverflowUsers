import Foundation
import Testing
@testable import StackOverflowUsers
@testable import StackOverflowService

@MainActor
struct DefaultUsersUseCaseTests {

    private let stubUserService = SpyUserService()
    private let stubFollowStore = SpyFollowStore()
    private var useCase: DefaultUsersUseCase!

    init() {
        useCase = DefaultUsersUseCase(
            userService: stubUserService,
            followStore: stubFollowStore
        )
    }

    @Test("Maps UserService results into UserViewModels with correct follow state")
    func usersMapsCorrectly() async throws {
        stubFollowStore.stubbedIsFollowedResult = [2: true]
        stubUserService.stubbedUsers = [
            User(
                badgeCounts: .init(bronze: 1, silver: 2, gold: 3),
                accountId: 10,
                isEmployee: false,
                lastModifiedDate: nil,
                lastAccessDate: Date(),
                reputationChangeYear: 1,
                reputationChangeQuarter: 1,
                reputationChangeMonth: 1,
                reputationChangeWeek: 1,
                reputationChangeDay: 1,
                reputation: 100,
                creationDate: Date(),
                userType: .registered,
                userId: 1,
                acceptRate: nil,
                aboutMe: nil,
                location: nil,
                websiteUrl: nil,
                link: "link",
                profileImage: "https://example.com/p1.png",
                displayName: "User 1",
                timedPenaltyDate: nil,
                age: nil
            ),
            User(
                badgeCounts: .init(bronze: 1, silver: 2, gold: 3),
                accountId: 11,
                isEmployee: false,
                lastModifiedDate: nil,
                lastAccessDate: Date(),
                reputationChangeYear: 1,
                reputationChangeQuarter: 1,
                reputationChangeMonth: 1,
                reputationChangeWeek: 1,
                reputationChangeDay: 1,
                reputation: 200,
                creationDate: Date(),
                userType: .registered,
                userId: 2,
                acceptRate: nil,
                aboutMe: nil,
                location: nil,
                websiteUrl: nil,
                link: "link",
                profileImage: "https://example.com/p2.png",
                displayName: "User 2",
                timedPenaltyDate: nil,
                age: nil
            )
        ]

        let result = try await useCase.users()

        #expect(result.count == 2)
        let first = try #require(result.first)
        #expect(first.id == 1)
        #expect(first.name == "User 1")
        #expect(first.followed == false)

        let second = try #require(result.last)
        #expect(second.id == 2)
        #expect(second.followed == true)
    }

    @Test("Throws error when UserService fails")
    func usersThrowsOnError() async throws {
        stubUserService.stubbedError = MockError.mock
        await #expect(throws: MockError.mock) {
            try await useCase.users()
        }
    }

    @Test("toggleFollowing follows a non-followed user")
    func toggleFollowingFollows() throws {
        stubFollowStore.stubbedIsFollowedResult = [:]

        let user = UserViewModel(
            id: 42,
            name: "Follow Me",
            reputation: 123,
            profileImageURL: URL(string: "https://example.com"),
            location: "Manchester",
            websiteURL: "https://websiteUrl.com",
            followed: false
        )

        useCase.toggleFollowing(of: user)

        #expect(stubFollowStore.invokedFollowParameters?.userId == 42)
        #expect(stubFollowStore.invokedUnfollow == false)
    }

    @Test("toggleFollowing unfollows an already-followed user")
    func toggleFollowingUnfollows() throws {
        stubFollowStore.stubbedIsFollowedResult = [99: true]
        let user = UserViewModel(
            id: 99,
            name: "Unfollow Me",
            reputation: 456,
            profileImageURL: URL(string: "https://example.com"),
            location: "Manchester",
            websiteURL: "https://websiteUrl.com",
            followed: true
        )

        useCase.toggleFollowing(of: user)

        #expect(stubFollowStore.invokedUnfollowParameters?.userId == 99)
        #expect(stubFollowStore.invokedFollow == false)
    }
}
