//
//  MockHTTPClient.swift
//  DetailDataTests
//
//  Created by 백래훈 on 11/12/25.
//

import Foundation
import NetworkInterface

final class MockHTTPClient: HTTPClient {
    struct Captured {
        var path: String
        var query: [URLQueryItem]
    }

    var captured: [Captured] = []
    var typedDTOs: [String: Any] = [:]
    var error: Error?

    func request<T>(
        _ path: String,
        query: [URLQueryItem]
    ) async throws -> T where T : Decodable {
        if let error = error { throw error }
        captured.append(Captured(path: path, query: query))

        guard let value = typedDTOs[path] else {
            throw URLError(.cannotFindHost)
        }

        guard let typed = value as? T else {
            throw DecodingError.typeMismatch(T.self, DecodingError.Context(codingPath: [], debugDescription: "Failed to decode response for path \(path)"))
        }

        return typed
    }
}
