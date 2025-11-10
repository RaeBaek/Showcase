//
//  TVDetailRepositoryImpl.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

import NetworkInterface
import DetailDomain

public final class TVDetailRepositoryImpl: TVDetailRepository {
    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func fetchDetail(_ input: DetailInput) async throws -> TVDetailEntity {
        let dto: TVDetailDTO = try await client.request(
            "/tv/\(input.id)",
            query: [URLQueryItem(name: "language", value: input.language)]
        )
        return dto.toEntity
    }
}
