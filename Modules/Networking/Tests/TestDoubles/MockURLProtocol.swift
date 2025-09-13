//
//  MockURLProtocol.swift
//  RequestMaker
//
//  Created by Andy Kayley on 10/09/2025.
//
import Foundation
import Testing

actor RequestHandlerStorage {
    private var requestHandler: ( @Sendable (URLRequest) async throws -> (URLResponse, Data))?

    func setHandler(_ handler: @Sendable @escaping (URLRequest) async throws -> (URLResponse, Data)) async {
        requestHandler = handler
    }

    func executeHandler(for request: URLRequest) async throws -> (URLResponse, Data) {
        guard let handler = requestHandler else {
            fatalError("No request handler set for \(request)")
        }
        return try await handler(request)
    }
}

final class MockURLProtocol: URLProtocol, @unchecked Sendable {

    private static let requestHandlerStorage = RequestHandlerStorage()

    static func setHandler(_ handler: @Sendable @escaping (URLRequest) async throws -> (URLResponse, Data)) async {
        await requestHandlerStorage.setHandler { request in
            try await handler(request)
        }
    }

    static func createResponse(
        url: URL,
        statusCode: Int,
        httpVersion: String? = nil,
        headerFields: [String: String]? = nil,
        stringResponse: String
    ) -> (URLResponse, Data) {
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: httpVersion,
            headerFields: headerFields
        )

        let responseData = stringResponse.data(using: .utf8)

        guard let response, let responseData else {
            fatalError("Failed to create response and/or data")
        }

        return (response, responseData)
    }

    func executeHandler(for request: URLRequest) async throws -> (URLResponse, Data) {
        return try await Self.requestHandlerStorage.executeHandler(for: request)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        Task {
            do {
                let (response, data) = try await self.executeHandler(for: request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override func stopLoading() {}
}
