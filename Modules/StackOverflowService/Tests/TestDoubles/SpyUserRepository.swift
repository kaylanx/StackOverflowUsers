@testable import StackOverflowService

final class SpyUserRepository: UserRepository {

    var invokedFetchUsers = false
    var invokedFetchUsersCount = 0

    var stubbbedFetchUsersResult: [User]!
    var stubbedFetchUsersError: Error?

    func fetchUsers() async throws -> [User] {
        invokedFetchUsers = true
        invokedFetchUsersCount += 1
        if let stubbedFetchUsersError {
            throw stubbedFetchUsersError
        }
        return stubbbedFetchUsersResult
    }
}
