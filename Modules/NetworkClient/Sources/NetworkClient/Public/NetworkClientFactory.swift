import Foundation

public enum NetworkClientFactory {
    public static func networkClient() -> NetworkClient {
        DefaultNetworkClient()
    }
}
