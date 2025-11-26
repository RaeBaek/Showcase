//
//  MockPeopleDetailUseCase.swift
//  DetailPresentationTests
//
//  Created by 백래훈 on 11/18/25.
//

import Foundation
@testable import DetailDomain

final class MockPeopleDetailUseCase: PeopleDetailUseCase {
    // MARK: - 현재 지역 언어
    let language = Locale.current.identifier

    // MARK: - 호출 기록
    private(set) var fetchDetailCallCount = 0
    private(set) var fetchCreditsCallCount = 0

    // MARK: - Stubbed 엔티티
    var stubDetail: PersonDetailEntity!
    var stubCredits: [KnownForItem] = []

    // MARK: - Stubbed 에러
    var error: Error?

    func fetchDetail(_ input: DetailInput) async throws -> PersonDetailEntity {
        fetchDetailCallCount += 1
        if let error { throw error }
        return stubDetail
    }

    func fetchCredits(_ input: DetailInput) async throws -> [KnownForItem] {
        fetchCreditsCallCount += 1
        if let error { throw error }
        return stubCredits
    }
}
