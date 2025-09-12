import Foundation
import NetworkClient

final class SpyNetworkClient: NetworkClient {

    var invokedFetch = false
    var invokedFetchCount = 0
    var invokedFetchParameters: (request: URLRequest, type: Any)?
    var invokedFetchParametersList = [(request: URLRequest, type: Any)]()

    var stubbedFetchResult: Any!
    var stubbedError: Error?

    func fetch<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T {
        invokedFetch = true
        invokedFetchCount += 1
        invokedFetchParameters = (request, type)
        invokedFetchParametersList.append((request, type))

        if let stubbedError {
            throw stubbedError
        }
        return stubbedFetchResult as! T
    }
}
