//
//  MockTVDetailUseCase.swift
//  DetailPresentationTests
//
//  Created by 백래훈 on 11/18/25.
//

import Foundation
@testable import DetailDomain

final class MockTVDetailUseCase: TVDetailUseCase {
    func fetchDetail(id: Int32) async throws -> TVDetailInfoEntity {
        <#code#>
    }
    
    func fetchCredits(id: Int32) async throws -> [CreditInfoEntity] {
        <#code#>
    }
    
    func fetchVideos(id: Int32) async throws -> [VideoItemEntity] {
        <#code#>
    }
    
    func fetchSimilars(id: Int32) async throws -> [SimilarItemEntity] {
        <#code#>
    }
}
