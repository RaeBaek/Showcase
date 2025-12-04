//
//  HTTPClient.swift
//  Network
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

/// 공통 네트워크 인터페이스 프로토콜
/// - 목적: TMDBClient뿐 아니라 MockClient, 다른 API 클라이언트도 쉽게 교체 가능하게 함
public protocol HTTPClient {
    /// 제네릭 요청 메서드 (GET 전용)
    /// - Parameters:
    ///   - path: base URL 뒤에 붙을 경로 (예: "movie/popular")
    ///   - query: URL 쿼리 파라미터 (예: language, page 등)
    /// - Returns: 디코딩된 제네릭 타입 T
    func request<T: Decodable>(
        _ path: String,
        query: [URLQueryItem]
    ) async throws -> T
}
