//
//  MovieDetailUseCase.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/1/25.
//

import Foundation

public protocol MovieDetailUseCase {
    func fetchDetail(id: Int32) async throws -> MovieDetailInfoEntity
    func fetchCredits(id: Int32) async throws -> [CreditPersonEntity]
    func fetchVideos(id: Int32) async throws -> [VideoItemEntity]
    func fetchSimilar(id: Int32) async throws -> [SimilarMovieItemEntity]
}

public final class MovieDetailUseCaseImpl: MovieDetailUseCase {

    private let repository: any MovieDetailRepository

    public init(repository: any MovieDetailRepository) {
        self.repository = repository
    }

    public func fetchDetail(id: Int32) async throws -> MovieDetailInfoEntity {
        let input = DetailInput(id: id, language: "ko-KR")
        let detail = try await self.repository.fetchDetail(input)
        return detail.toDetail
    }

    public func fetchCredits(id: Int32) async throws -> [CreditPersonEntity] {
        let input = DetailInput(id: id, language: "ko-KR")
        let credits = try await self.repository.fetchCredits(input)
        return credits.cast.map { $0.toCredit }
    }

    public func fetchVideos(id: Int32) async throws -> [VideoItemEntity] {
        let input = DetailInput(id: id, language: "ko-KR")
        let videos = try await self.repository.fetchVideos(input)
        return videos.results.map { $0.toVideoItemEntity }
    }

    public func fetchSimilar(id: Int32) async throws -> [SimilarMovieItemEntity] {
        let input = DetailInput(id: id, language: "ko-KR")
        let similars = try await self.repository.fetchSimilars(input)
        return similars.results.map { $0.toSimilarMovieItemEntity }
    }
}
