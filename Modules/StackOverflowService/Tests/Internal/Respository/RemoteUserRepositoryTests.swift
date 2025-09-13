import Foundation
import Testing

import Networking

@testable import StackOverflowService

final class RemoteUserRepositoryTests {

    private let userRepository: UserRepository!
    private let spyNetworkClient = SpyNetworkClient()

    init() {
        userRepository = RemoteUserRepository(
            networkClient: spyNetworkClient,
            baseURL: URL(string: "scheme://unit-test")!
        )
    }

    @Test("When requesting data, it should be fetched successfully")
    func successfulResponse() async throws {

        let expectedUser = User.mock
        spyNetworkClient.stubbedFetchResult = UserResponse(
            items: [expectedUser]
        )

        let users = try await userRepository.fetchUsers()

        #expect(spyNetworkClient.invokedFetch)

        let (request, _) = try #require(spyNetworkClient.invokedFetchParameters)
        let expectedUrl = "scheme://unit-test/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow"

        #expect(request.url?.absoluteString == expectedUrl)
        #expect(users.count == 1)

        let user = try #require(users.first)

        #expect(user == expectedUser)
    }

    @Test("When requesting data, it should be fetched successfully")
    func errorResponse() async throws {

        enum MockError: Error, Equatable {
            case mock
        }

        spyNetworkClient.stubbedError = MockError.mock

        await #expect(throws: MockError.mock) {
            try await userRepository.fetchUsers()
        }

        #expect(spyNetworkClient.invokedFetch)

        let (request, _) = try #require(spyNetworkClient.invokedFetchParameters)
        let expectedUrl = "scheme://unit-test/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow"

        #expect(request.url?.absoluteString == expectedUrl)
    }
}
