import Foundation

public enum NetworkClientFactory {
    public static func networkClient(
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970
    ) -> NetworkClient {
        DefaultNetworkClient(
            keyDecodingStrategy: keyDecodingStrategy,
            dateDecodingStrategy: dateDecodingStrategy
        )
    }
}
