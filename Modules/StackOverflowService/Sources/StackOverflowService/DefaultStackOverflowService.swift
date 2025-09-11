import Foundation

final class DefaultStackOverflowService: StackOverflowService {
    func fetchUsers() async throws -> [StackOverFlowUser] {
        [StackOverFlowUser()]
    }
}
