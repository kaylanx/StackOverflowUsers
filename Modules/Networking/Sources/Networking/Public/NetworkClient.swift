import Foundation

public protocol NetworkClient {
    func fetch<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T
}

