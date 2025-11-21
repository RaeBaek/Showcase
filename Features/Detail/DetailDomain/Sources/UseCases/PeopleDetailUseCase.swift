//
//  PeopleDetailUseCase.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/7/25.
//

import Foundation

public protocol PeopleDetailUseCase {
    func fetchDetail(_ input: DetailInput) async throws -> PersonDetailEntity
    func fetchCredits(_ input: DetailInput) async throws -> [KnownForItem]
}

public final class PeopleDetailUseCaseImpl: PeopleDetailUseCase {

    private let repository: any PeopleDetailRepository

    public init(repository: any PeopleDetailRepository) {
        self.repository = repository
    }

    public func fetchDetail(_ input: DetailInput) async throws -> PersonDetailEntity {
        let detail = try await self.repository.fetchDetail(input)
        return detail.toPersonDetailEntity
    }

    public func fetchCredits(_ input: DetailInput) async throws -> [KnownForItem] {
        let credits = try await self.repository.fetchCredits(input)
        return (credits.cast + credits.crew).toKnownForItems()
    }
}
