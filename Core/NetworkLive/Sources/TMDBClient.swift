//
//  TMDBClient.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation
import NetworkInterface

public class TMDBClient: HTTPClient {
    private let accessToken: String
    private let baseUrlString: String
    private let baseUrl: URL

    public init() {
        // 1. Access Token 로드
        guard let token = Bundle.main.object(forInfoDictionaryKey: "TMDB_READ_ACCESS_TOKEN") as? String,
              !token.isEmpty else {
            fatalError("TMDB_READ_ACCESS_TOKEN not found or is invalid in Info.plist")
        }
        self.accessToken = token

        // 2. Base URL String 로드
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "TMDB_BASE_URL_STRING") as? String,
              !urlString.isEmpty else {
            fatalError("TMDB_BASE_URL_STRING not found or is invalid in Info.plist")
        }
        self.baseUrlString = urlString

        // 3. Base URL 생성
        guard let url = URL(string: "https://" + baseUrlString) else {
            fatalError("Failed to create baseUrl. Check TMDB_BASE_URL_STRING in Info.plist. It should NOT include 'https://'")
        }
        self.baseUrl = url
    }

    public func request<T: Decodable>(
        _ path: String,
        query: [URLQueryItem] = []
    ) async throws -> T {

        // URL 구성 실패
        guard var components = URLComponents(
            url: baseUrl.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = (components.queryItems ?? []) + query

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(accessToken)"
        ]

        print("request: \(request)")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200..<300).contains(http.statusCode) else {
                throw NetworkError.statusCode(http.statusCode)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.underlying(error)
        }
    }
}
