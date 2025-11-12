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
    func fetchSimilars(_ input: DetailInput) async throws -> SimilarEntity
}

public protocol PeopleDetailRepository: DetailRepository where Entity == PersonEntity {
    func fetchDetail(_ input: DetailInput) async throws -> PersonEntity
    func fetchCredits(_ input: DetailInput) async throws -> PersonCombineCreditsEntity
}

public protocol TVDetailRepository: DetailRepository where Entity == TVDetailEntity {
    func fetchDetail(_ input: DetailInput) async throws -> TVDetailEntity
    func fetchCredits(_ input: DetailInput) async throws -> CreditsEntity
    func fetchVideos(_ input: DetailInput) async throws -> VideoEntity
    func fetchSimilars(_ input: DetailInput) async throws -> SimilarEntity
}
