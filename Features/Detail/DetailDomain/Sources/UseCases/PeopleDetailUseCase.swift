//
//  PeopleDetailUseCase.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/7/25.
//

import Foundation

public protocol PeopleDetailUseCase {
    func fetchDetail(id: Int32) async throws -> PersonDetailEntity
    func fetchCredits(id: Int32) async throws -> [KnownForItem]
}

public final class PeopleDetailUseCaseImpl: PeopleDetailUseCase {

    private let repository: any PeopleDetailRepository

    public init(repository: any PeopleDetailRepository) {
        self.repository = repository
    }

    public func fetchDetail(id: Int32) async throws -> PersonDetailEntity {
        let input = DetailInput(id: id, language: "ko-KR")
        let detail = try await self.repository.fetchDetail(input)
        return detail.toPersonDetailEntity
    }

    public func fetchCredits(id: Int32) async throws -> [KnownForItem] {
        let input = DetailInput(id: id, language: "ko-KR")
        let credits = try await self.repository.fetchCredits(input)
        return (credits.cast + credits.crew).toKnownForItems()
    }

}
