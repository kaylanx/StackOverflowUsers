import StackOverflowService

final class SpyUserService: UserService {

    var invokedFetchUsers = false
    var invokedFetchUsersCount = 0
    var stubbedUsers: [User]!
    var stubbedError: Error?

    func fetchUsers() async throws -> [User] {
        invokedFetchUsers = true
        invokedFetchUsersCount += 1
        if let stubbedError {
            throw stubbedError
        }
        return stubbedUsers
    }
}
