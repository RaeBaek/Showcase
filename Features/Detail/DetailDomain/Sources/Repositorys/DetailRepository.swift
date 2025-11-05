//
//  DetailRepository.swift
//  DetailDomain
//
//  Created by 백래훈 on 10/31/25.
//

import Foundation

public protocol DetailRepository<Entity>: AnyObject {
    associatedtype Entity: Identifiable where Entity.ID == Int32
    func fetchDetail(_ input: DetailInput) async throws -> Entity
}

public protocol MovieDetailRepository: DetailRepository where Entity == MovieDetailEntity {
    func fetchDetail(_ input: DetailInput) async throws -> MovieDetailEntity
    func fetchCredits(_ input: DetailInput) async throws -> CreditsEntity
    func fetchVideos(_ input: DetailInput) async throws -> VideoEntity
    func fetchSimilars(_ input: DetailInput) async throws -> SimilarMovieEntity
}

public protocol PeopleDetailRepository: DetailRepository {
    func fetchDetail(_ input: DetailInput) async throws
}

public protocol TVDetailRepository: DetailRepository {
    func fetchDetail(_ input: DetailInput) async throws
}
