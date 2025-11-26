//
//  MockTVDetailUseCase.swift
//  DetailPresentationTests
//
//  Created by 백래훈 on 11/18/25.
//

import Foundation
@testable import DetailDomain

final class MockTVDetailUseCase: TVDetailUseCase {
    // MARK: - 현재 지역 언어
    let language = Locale.current.identifier
    
    // MARK: - 호출 기록
    private(set) var fetchDetailCallCount = 0
    private(set) var fetchCreditsCallCount = 0
    private(set) var fetchVideosCallCount = 0
    private(set) var fetchSimilarsCallCount = 0

    // MARK: - Stubbed 엔티티
    var stubDetail: TVDetailInfoEntity!
    var stubCredits: [CreditInfoEntity] = []
    var stubVideos: [VideoItemEntity] = []
    var stubSimilars: [SimilarItemEntity] = []

    // MARK: - Stubbed 에러
    var error: Error?

    func fetchDetail(_ input: DetailInput) async throws -> TVDetailInfoEntity {
        fetchDetailCallCount += 1
        if let error { throw error }
        return stubDetail
    }
    
    func fetchCredits(_ input: DetailInput) async throws -> [CreditInfoEntity] {
        fetchCreditsCallCount += 1
        if let error { throw error }
        return stubCredits
    }
    
    func fetchVideos(_ input: DetailInput) async throws -> [VideoItemEntity] {
        fetchVideosCallCount += 1
        if let error { throw error }
        return stubVideos
    }
    
    func fetchSimilars(_ input: DetailInput) async throws -> [SimilarItemEntity] {
        fetchSimilarsCallCount += 1
        if let error { throw error }
        return stubSimilars
    }
}
