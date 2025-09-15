@testable import StackOverflowUsers

final class SpyUsersUseCase: UsersUseCase {

    var invokedUsers = false
    var invokedUsersCount = 0
    var stubbedUsers: [UserViewModel]!
    var stubbedError: Error?

    func users() async throws -> [UserViewModel] {
        invokedUsers = true
        invokedUsersCount += 1
        if let stubbedError {
            throw stubbedError
        }
        return stubbedUsers
    }

    var invokedToggleFollowing = false
    var invokedToggleFollowingCount = 0
    var invokedToggleFollowingParameters: (user: UserViewModel, Void)?
    var invokedToggleFollowingParametersList = [(user: UserViewModel, Void)]()

    func toggleFollowing(of user: UserViewModel) {
        invokedToggleFollowing = true
        invokedToggleFollowingCount += 1
        invokedToggleFollowingParameters = (user, ())
        invokedToggleFollowingParametersList.append((user, ()))
    }
}
