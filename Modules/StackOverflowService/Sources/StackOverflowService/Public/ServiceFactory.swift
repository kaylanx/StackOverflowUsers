import Foundation
import NetworkClient

public enum ServiceFactory {
    public static func userService(
        networkClient: NetworkClient,
        baseURL: URL
    ) -> UserService {

        let userRepository = RemoteUserRepository(
            networkClient: networkClient,
            baseURL: baseURL
        )

        return RemoteUserService(
            userRepository: userRepository
        )
    }
}
