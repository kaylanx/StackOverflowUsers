import Foundation
import Testing

@testable import NetworkClient

// Tests are run sequentially to ensure that modifications to
// protocolClasses using MockURLProtocol do not leak into or
// interfere with other tests.
@Suite(.serialized)
final class DefaultNetworkClientTests {

    private let networkClient: DefaultNetworkClient!

    init() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        networkClient = DefaultNetworkClient(
            session: session,
            keyDecodingStrategy: .convertFromSnakeCase
        )
    }

    deinit {
        URLSessionConfiguration.default.protocolClasses = []
    }

    struct SciFiCharacter: Decodable {
        let id: Int
        let franchise: String
        let name: String
        let totalAppearances: Int
    }

    @Test("When requesting data, it should be fetched successfully")
    func successfulResponse() async throws {

        let url = try #require(URL(string: "https://unit.testing.com"))

        await MockURLProtocol.setHandler { request in
            let response = """
            { 
                "id": 123,
                "franchise": "Star Wars",
                "name": "Obi-Wan Kenobi",
                "total_appearances": 22
            }
            """

            return MockURLProtocol.createResponse(
                url: url,
                statusCode: 200,
                stringResponse: response
            )
        }

        let request = URLRequest(url: url)

        let character = try await networkClient.fetch(
            request,
            as: SciFiCharacter.self
        )

        #expect(character.id == 123)
        #expect(character.franchise == "Star Wars")
        #expect(character.name == "Obi-Wan Kenobi")
        #expect(character.totalAppearances == 22)
    }

    @Test("When invalid response returned, NetworkError.invalidResponse should be thrown")
    func invalidResponse() async throws {
        let url = try #require(URL(string: "https://unit.testing.com"))
        
        await MockURLProtocol.setHandler { request in
            (URLResponse(
                url: url,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            ), "".data(using: .utf8)!)
        }

        let request = URLRequest(url: url)

        await #expect {
            try await networkClient.fetch(
                request,
                as: SciFiCharacter.self
            )
        } throws: { error in
            guard let error = error as? NetworkError else { return false }
            return switch error {
            case .invalidResponse: true
            default: false
            }
        }
    }

    @Test("When 500 response returned, NetworkError.httpError(500) should be thrown")
    func fiveHundredError() async throws {

        let url = try #require(URL(string: "https://unit.testing.com"))

        await MockURLProtocol.setHandler { request in
            MockURLProtocol.createResponse(
                url: url,
                statusCode: 500,
                stringResponse: ""
            )
        }

        let request = URLRequest(url: url)

        await #expect {
            try await networkClient.fetch(
                request,
                as: SciFiCharacter.self
            )
        } throws: { error in
            guard let error = error as? NetworkError else { return false }
            return switch error {
            case .httpError(let errorCode): errorCode == 500
            default: false
            }
        }
    }

    @Test("When successful response but json decoding failed, NetworkError.decodingFailed should be thrown")
    func jsonDecodingError() async throws {

        let url = try #require(URL(string: "https://unit.testing.com"))

        await MockURLProtocol.setHandler { request in
            MockURLProtocol.createResponse(
                url: url,
                statusCode: 200,
                stringResponse: "{ }"
            )
        }

        let request = URLRequest(url: url)

        await #expect {
            try await networkClient.fetch(
                request,
                as: SciFiCharacter.self
            )
        } throws: { error in
            guard let error = error as? NetworkError else { return false }
            return switch error {
            case .decodingFailed(let error): error is DecodingError
            default: false
            }
        }
    }
}
