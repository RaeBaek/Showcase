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
        var components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        components.queryItems = components.queryItems.map { $0 + query } ?? query

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

    // MARK: EndPoints
    // MARK: 수정 리스트 3종
    func movieModifyList() async throws -> ModifyListResponse {
        try await self.requestTMDB("/movie/changes", query: [URLQueryItem(name: "page", value: "1")])
    }

    func peopleModifyList() async throws -> ModifyListResponse {
        try await self.requestTMDB("/person/changes", query: [URLQueryItem(name: "page", value: "1")])
    }

    func tvModifyList() async throws -> ModifyListResponse {
        try await self.requestTMDB("/tv/changes", query: [URLQueryItem(name: "page", value: "1")])
    }

    // MARK: 인기 리스트 3종
    func moviePopularList() async throws -> PopularListResponse<PopularMovieDTO> {
        try await self.requestTMDB(
            "/movie/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
    }

    func peoplePopularList() async throws -> PopularListResponse<PopularPeopleDTO> {
        try await self.requestTMDB(
            "/person/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
    }

    func tvPopularList() async throws -> PopularListResponse<PopularTVDTO> {
        try await self.requestTMDB(
            "/tv/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
    }
}
