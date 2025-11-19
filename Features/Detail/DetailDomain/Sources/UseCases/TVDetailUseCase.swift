//
//  TVDetailUseCase.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

public protocol TVDetailUseCase {
    func fetchDetail(id: Int32) async throws -> TVDetailInfoEntity
    func fetchCredits(id: Int32) async throws -> [CreditInfoEntity]
    func fetchVideos(id: Int32) async throws -> [VideoItemEntity]
    func fetchSimilars(id: Int32) async throws -> [SimilarItemEntity]
}

public final class TVDetailUseCaseImpl: TVDetailUseCase {

    private let repository: any TVDetailRepository

    public init(repository: any TVDetailRepository) {
        self.repository = repository
    }

    public func fetchDetail(id: Int32) async throws -> TVDetailInfoEntity {
        let input = DetailInput(id: id, language: "ko-KR")
        let detail = try await self.repository.fetchDetail(input)
        return detail.toInfo
    }

    public func fetchCredits(id: Int32) async throws -> [CreditInfoEntity] {
        let input = DetailInput(id: id, language: "ko-KR")
        let credits = try await self.repository.fetchCredits(input)
        return credits.cast.map { $0.toCredit } + credits.crew.map { $0.toCredit }
    }

    public func fetchVideos(id: Int32) async throws -> [VideoItemEntity] {
        let input = DetailInput(id: id, language: "ko-KR")
        let videos = try await self.repository.fetchVideos(input)
        return videos.results.map { $0.toVideoItemEntity }
    }

    public func fetchSimilars(id: Int32) async throws -> [SimilarItemEntity] {
        let input = DetailInput(id: id, language: "ko-KR")
        let similars = try await self.repository.fetchSimilars(input)
        return similars.results.map { $0.toSimilarMovieItemEntity }
    }
}
