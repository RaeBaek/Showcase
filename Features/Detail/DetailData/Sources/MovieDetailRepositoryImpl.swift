//
//  MovieDetailRepositoryImpl.swift
//  DetailData
//
//  Created by 백래훈 on 10/31/25.
//

import Foundation
import NetworkInterface
import DetailDomain

final class MovieDetailRepositoryImpl: MovieDetailRepository {

    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func fetchDetail(_ input: DetailInput) async throws {
        let dto: MovieDetailDTO = try await self.client.request(
            "/movie/\(input.id)",
            query: [URLQueryItem(name: "language", value: input.language)]
        )
    }
}
