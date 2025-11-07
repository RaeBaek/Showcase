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

    private let reposiotry: any PeopleDetailRepository

    public init(reposiotry: any PeopleDetailRepository) {
        self.reposiotry = reposiotry
    }

    public func fetchDetail(id: Int32) async throws -> PersonDetailEntity {
        let input = DetailInput(id: id, language: "ko-KR")
        let detail = try await self.reposiotry.fetchDetail(input)
        return detail.toPersonDetailEntity
    }

    public func fetchCredits(id: Int32) async throws -> [KnownForItem] {
        let input = DetailInput(id: id, language: "ko-KR")
        let credits = try await self.reposiotry.fetchCredits(input)
        return credits
    }

}
