import Foundation
import Networking

protocol UserRepository {
    func fetchUsers() async throws -> [User]
}

final class RemoteUserRepository: UserRepository {

    private static let usersPath = "/users"
    private static let usersQueryItems = [
        URLQueryItem(name: "page", value: "1"),
        URLQueryItem(name: "pagesize", value: "20"),
        URLQueryItem(name: "order", value: "desc"),
        URLQueryItem(name: "sort", value: "reputation"),
        URLQueryItem(name: "site", value: "stackoverflow")
    ]
    private let networkClient: NetworkClient
    private let baseURL: URL

    init(
        networkClient: NetworkClient,
        baseURL: URL
    ) {
        self.networkClient = networkClient
        self.baseURL = baseURL
    }

    func fetchUsers() async throws -> [User] {
        let url = baseURL
            .appendingPathComponent(Self.usersPath)
            .appending(queryItems: Self.usersQueryItems)
        let urlRequest = URLRequest(url: url)
        let userResponse = try await networkClient.fetch(urlRequest, as: UserResponse.self)
        return userResponse.items
    }
}
