//
//  TVDetailUseCase.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

public protocol TVDetailUseCase {
    func fetchDetail(_ input: DetailInput) async throws -> TVDetailInfoEntity
    func fetchCredits(_ input: DetailInput) async throws -> [CreditInfoEntity]
    func fetchVideos(_ input: DetailInput) async throws -> [VideoItemEntity]
    func fetchSimilars(_ input: DetailInput) async throws -> [SimilarItemEntity]
}

public final class TVDetailUseCaseImpl: TVDetailUseCase {

    private let repository: any TVDetailRepository

    public init(repository: any TVDetailRepository) {
        self.repository = repository
    }

    public func fetchDetail(_ input: DetailInput) async throws -> TVDetailInfoEntity {
        let detail = try await self.repository.fetchDetail(input)
        return detail.toInfo
    }

    public func fetchCredits(_ input: DetailInput) async throws -> [CreditInfoEntity] {
        let credits = try await self.repository.fetchCredits(input)
        return credits.cast.map { $0.toCredit } + credits.crew.map { $0.toCredit }
    }

    public func fetchVideos(_ input: DetailInput) async throws -> [VideoItemEntity] {
        let videos = try await self.repository.fetchVideos(input)
        return videos.results.map { $0.toVideoItemEntity }
    }

    public func fetchSimilars(_ input: DetailInput) async throws -> [SimilarItemEntity] {
        let similars = try await self.repository.fetchSimilars(input)
        return similars.results.map { $0.toSimilarMovieItemEntity }
    }
}
