//
//  NetworkErrorMapper.swift
//  DataInterface
//
//  Created by 백래훈 on 12/2/25.
//

import Foundation

import NetworkInterface

import DomainInterface

public struct NetworkErrorMapper {
    public static func toDomain(_ error: NetworkError) -> DomainError {
        switch error {
        case .invalidURL: return .unknown
        case .invalidResponse: return .serverError

        case .statusCode(let code):
            switch code {
            case 401: return .unauthorized
            case 403: return .forbidden
            case 404: return .notFound
            case 429: return .tooManyRequests
            case 500...599: return .serverError
            default: return .unknown
            }

        case .timeout: return .timeout
        case .decodingError: return .decoding
        case .missingAPIKey: return .unauthorized

        case .underlying(let err):
            if let urlErr = err as? URLError {
                switch urlErr.code {
                case .notConnectedToInternet: return .network
                case .timedOut: return .timeout
                default: return .network
                }
            }
            return .unknown
        }
    }
}
