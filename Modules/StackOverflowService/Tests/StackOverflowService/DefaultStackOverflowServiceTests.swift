import Foundation
import Testing

@testable import StackOverflowService

final class DefaultStackOverflowServiceTests {

    private let stackOverflowService: DefaultStackOverflowService!

    init() {
        stackOverflowService = DefaultStackOverflowService()
    }

    @Test("When requesting data, it should be fetched successfully")
    func successfulResponse() async throws {
        let users = try await stackOverflowService.fetchUsers()
        #expect(users.count == 1)
    }
}
