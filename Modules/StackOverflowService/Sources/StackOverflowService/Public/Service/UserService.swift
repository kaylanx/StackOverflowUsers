import Foundation

public protocol UserService {
    func fetchUsers() async throws -> [User]
}
