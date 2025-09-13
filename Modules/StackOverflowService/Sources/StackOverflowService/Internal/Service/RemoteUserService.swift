import Foundation
import Networking

final class RemoteUserService: UserService {

    private let userRepository: UserRepository

    init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    func fetchUsers() async throws -> [User] {
        do {
            return try await userRepository.fetchUsers()
        } catch NetworkError.invalidResponse {
            throw UserServiceError.invalidResponse
        }
    }
}
