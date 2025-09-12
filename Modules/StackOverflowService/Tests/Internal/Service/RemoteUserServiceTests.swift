import Testing
import NetworkClient
@testable import StackOverflowService

struct RemoteUserServiceTests {

    private let spyUserRepository = SpyUserRepository()
    private let service: RemoteUserService!

    init() {
        service = RemoteUserService(userRepository: spyUserRepository)
    }

    @Test("fetchUsers returns the users from repository")
    func testFetchUsersSuccess() async throws {
        let mockUser = User.mock
        spyUserRepository.stubbbedFetchUsersResult = [mockUser]

        let users = try await service.fetchUsers()

        #expect(users.count == 1)
        #expect(users.first == mockUser)
    }

    @Test("fetchUsers throws invalidResponse when repository fails with NetworkError.invalidResponse")
    func testFetchUsersInvalidResponse() async throws {
        spyUserRepository.stubbedFetchUsersError = NetworkError.invalidResponse

        await #expect(throws: UserServiceError.invalidResponse) {
            try await service.fetchUsers()
        }
    }
}
