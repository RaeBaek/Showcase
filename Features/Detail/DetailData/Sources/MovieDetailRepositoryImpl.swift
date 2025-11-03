//
//  MovieDetailRepositoryImpl.swift
//  DetailData
//
//  Created by 백래훈 on 10/31/25.
//

import Foundation
import NetworkInterface
import DetailDomain

public final class MovieDetailRepositoryImpl: MovieDetailRepository {

    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func fetchDetail(_ input: DetailInput) async throws -> MovieDetailEntity {
        let dto: MovieDetailDTO = try await self.client.request(
            "/movie/\(input.id)",
            query: [URLQueryItem(name: "language", value: input.language)])
        return dto.toEntity
    }
}
