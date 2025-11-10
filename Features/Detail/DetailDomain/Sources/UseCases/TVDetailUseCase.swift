//
//  TVDetailUseCase.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

public protocol TVDetailUseCase {
    func fetchDetail(id: Int32) async throws -> TVInfoEntity
}

public final class TVDetailUseCaseImpl: TVDetailUseCase {

    private let repository: any TVDetailRepository

    public init(repository: any TVDetailRepository) {
        self.repository = repository
    }

    public func fetchDetail(id: Int32) async throws -> TVInfoEntity {
        let input = DetailInput(id: id, language: "ko-KR")
        let detail = try await self.repository.fetchDetail(input)
        return detail.toInfo
    }
}
