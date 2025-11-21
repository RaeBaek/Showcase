//
//  MovieDetailUseCase.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/1/25.
//

import Foundation

public protocol MovieDetailUseCase {
    func fetchDetail(_ input: DetailInput) async throws -> MovieDetailInfoEntity
    func fetchCredits(_ input: DetailInput) async throws -> [CreditInfoEntity]
    func fetchVideos(_ input: DetailInput) async throws -> [VideoItemEntity]
    func fetchSimilar(_ input: DetailInput) async throws -> [SimilarItemEntity]
}

public final class MovieDetailUseCaseImpl: MovieDetailUseCase {

    private let repository: any MovieDetailRepository

    public init(repository: any MovieDetailRepository) {
        self.repository = repository
    }

    public func fetchDetail(_ input: DetailInput) async throws -> MovieDetailInfoEntity {
        let detail = try await self.repository.fetchDetail(input)
        return detail.toDetail
    }

    public func fetchCredits(_ input: DetailInput) async throws -> [CreditInfoEntity] {
        let credits = try await self.repository.fetchCredits(input)
        return credits.cast.map { $0.toCredit } + credits.crew.map { $0.toCredit }
    }

    public func fetchVideos(_ input: DetailInput) async throws -> [VideoItemEntity] {
        let videos = try await self.repository.fetchVideos(input)
        return videos.results.map { $0.toVideoItemEntity }
    }

    public func fetchSimilar(_ input: DetailInput) async throws -> [SimilarItemEntity] {
        let similars = try await self.repository.fetchSimilars(input)
        return similars.results.map { $0.toSimilarMovieItemEntity }
    }
}
