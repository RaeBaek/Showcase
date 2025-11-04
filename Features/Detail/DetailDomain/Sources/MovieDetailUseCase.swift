//
//  MovieDetailUseCase.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/1/25.
//

import Foundation

public protocol MovieDetailUseCase {
    func fetchDetail(id: Int32) async throws -> MovieDetailInfoEntity
//    func fetchCredits(id: Int32) async throws -> [CreditPersonEntity]
//    func fetchVideos(id: Int32) async throws -> [VideoItemEntity]
//    func fetchSimilar(id: Int32) async throws -> [SimilarMovieEntity]
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

//    public func fetchCredits(id: Int32) async throws -> [CreditPersonEntity] {
//        let input = DetailInput(id: id, language: "ko-KR")
//        return try await self.repository.fetchDetail(input)
//    }
//
//    public func fetchVideos(id: Int32) async throws -> [VideoItemEntity] {
//        let input = DetailInput(id: id, language: "ko-KR")
//    }
//
//    public func fetchSimilar(id: Int32) async throws -> [SimilarMovieEntity] {
//        let input = DetailInput(id: id, language: "ko-KR")
//    }
}
