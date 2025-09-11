import Foundation

public struct StackOverFlowUser: Decodable { }

public protocol StackOverflowService {
    func fetchUsers() async throws -> [StackOverFlowUser]
}

