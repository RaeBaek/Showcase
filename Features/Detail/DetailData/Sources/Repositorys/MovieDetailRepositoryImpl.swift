//
//  MovieDetailRepositoryImpl.swift
//  DetailData
//
//  Created by 백래훈 on 10/31/25.
//

import Foundation
import NetworkInterface
import DetailDomain

public final class MovieDetailRepositoryImpl: MovieDetailRepository {

    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func fetchDetail(_ input: DetailInput) async throws -> MovieDetailEntity {
        let dto: MovieDetailDTO = try await self.client.request(
            "/movie/\(input.id)",
            query: [URLQueryItem(name: "language", value: input.language)]
        )
        return dto.toEntity
    }

    public func fetchCredits(_ input: DetailInput) async throws -> CreditsEntity {
        let dto: CreditsDTO = try await self.client.request(
            "/movie/\(input.id)/credits",
            query: [URLQueryItem(name: "language", value: input.language)]
        )
        return dto.toEntity
    }

    public func fetchVideos(_ input: DetailInput) async throws -> VideoEntity {
        let dto: VideoDTO = try await self.client.request(
            "movie/\(input.id)/videos",
            query: [URLQueryItem(name: "language", value: input.language)]
        )
        return dto.toEntity
    }

    public func fetchSimilars(_ input: DetailInput) async throws -> SimilarEntity {
        let dto: SimilarDTO = try await self.client.request(
            "movie/\(input.id)/similar",
            query: [
                URLQueryItem(name: "language", value: input.language),
                URLQueryItem(name: "page", value: "\(input.page)")
            ]
        )
        return dto.toEntity
    }
}
