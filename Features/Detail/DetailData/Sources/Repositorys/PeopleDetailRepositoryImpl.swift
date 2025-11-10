//
//  PeopleDetailRepositoryImpl.swift
//  DetailData
//
//  Created by 백래훈 on 11/7/25.
//

import Foundation
import NetworkInterface
import DetailDomain

public final class PeopleDetailRepositoryImpl: PeopleDetailRepository {

    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func fetchDetail(_ input: DetailInput) async throws -> PersonEntity {
        let dto: PersonDTO = try await self.client.request(
            "/person/\(input.id)",
            query: [URLQueryItem(name: "language", value: input.language)]
        )
        return dto.toEntity
    }
    
    public func fetchCredits(_ input: DetailInput) async throws -> PersonCombineCreditsEntity {
        let dto: PersonCombineCreditsDTO = try await self.client.request(
            "/person/\(input.id)/combined_credits",
            query: [URLQueryItem(name: "language", value: input.language)]
        )
        return dto.toEntity
    }
}
