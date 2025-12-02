//
//  NetworkError.swift
//  NetworkInterface
//
//  Created by 백래훈 on 12/2/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case underlying(Error)
    case timeout
    case missingAPIKey
}
