//
//  MockMovieDetailRepository.swift
//  DetailDomainTests
//
//  Created by 백래훈 on 11/17/25.
//

import Foundation
@testable import DetailDomain

final class MockMovieDetailRepository: MovieDetailRepository {

    // MARK: - Inputs 캡쳐
    private(set) var detailInputs: [DetailInput] = []
    private(set) var creditsInputs: [DetailInput] = []
    private(set) var videosInputs: [DetailInput] = []
    private(set) var similarsInputs: [DetailInput] = []

    // MARK: - Stubbed 엔티티
    var stubDetail: MovieDetailEntity!
    var stubCredits: CreditsEntity!
    var stubVideos: VideoEntity!
    var stubSimilars: SimilarEntity!

    // MARK: - Stubbed 에러
    var error: Error?

    func fetchDetail(_ input: DetailInput) async throws -> MovieDetailEntity {
        if let error { throw error }
        detailInputs.append(input)
        return stubDetail
    }
    
    func fetchCredits(_ input: DetailInput) async throws -> CreditsEntity {
        if let error { throw error }
        creditsInputs.append(input)
        return stubCredits
    }
    
    func fetchVideos(_ input: DetailInput) async throws -> VideoEntity {
        if let error { throw error }
        videosInputs.append(input)
        return stubVideos
    }
    
    func fetchSimilars(_ input: DetailInput) async throws -> SimilarEntity {
        if let error { throw error }
        similarsInputs.append(input)
        return stubSimilars
    }
}
