//
//  MovieDetailUseCase.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/1/25.
//

import Foundation

public protocol MovieDetailUseCase {
    func fetchDetail(id: Int) async throws -> MovieDetailEntity
    func fetchCredits(id: Int) async throws -> [CreditPersonEntity]
    func fetchVideos(id: Int) async throws -> [VideoItemEntity]
    func fetchSimilar(id: Int) async throws -> [SimilarMovieEntity]
}
