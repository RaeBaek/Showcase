//
//  TMDBClient.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation

class TMDBClient {
    static let shared = TMDBClient()
    private init() {}

    private let accessToken = Bundle.main.object(forInfoDictionaryKey: "TMDB_READ_ACCESS_TOKEN") as? String ?? "UNKNOWN"
    private let baseUrlString = Bundle.main.object(forInfoDictionaryKey: "TMDB_BASE_URL_STRING") as? String ?? "UNKNOWN"
    private lazy var baseUrl = URL(string: "https://" + baseUrlString)!

    func requestTMDB<T: Decodable>(_ path: String, query: [URLQueryItem] = []) async throws -> T {
        print(baseUrlString)
        print(baseUrl)
        var components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = components.queryItems.map { $0 + query } ?? query

        print(components.url!)

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(accessToken)"
        ]

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: EndPoints (인기 리스트 3종)
    func movieList() async throws -> ModifyListResponse {
        try await self.requestTMDB("/movie/changes", query: [URLQueryItem(name: "page", value: "1")])
    }

    func peopleList() async throws -> ModifyListResponse {
        try await self.requestTMDB("/person/changes", query: [URLQueryItem(name: "page", value: "1")])
    }

    func tvList() async throws -> ModifyListResponse {
        try await self.requestTMDB("/tv/changes", query: [URLQueryItem(name: "page", value: "1")])
    }
}
