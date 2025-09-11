import Foundation

public enum NetworkError: Error {
    case invalidResponse
    case decodingFailed(Error)
    case httpError(Int)
}
