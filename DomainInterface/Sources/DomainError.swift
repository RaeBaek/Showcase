//
//  DomainError.swift
//  DetailInterface
//
//  Created by 백래훈 on 12/2/25.
//

import Foundation

public enum DomainError: Error {
    case network                // 일반 네트워크 연결 문제 (오프라인 등)
    case unauthorized           // 401
    case forbidden              // 403
    case notFound               // 404
    case serverError            // 5xx
    case decoding               // JSON 디코딩 실패
    case timeout                // 요청 타임아웃
    case tooManyRequests        // 429
    case unknown                // 예측 불가능한 에러
}
