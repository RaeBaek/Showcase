//
//  PeopleDetailRepositoryImpl.swift
//  DetailData
//
//  Created by 백래훈 on 11/7/25.
//

import Foundation

import NetworkInterface

import DataInterface

import DetailDomain

public final class PeopleDetailRepositoryImpl: PeopleDetailRepository {

    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func fetchDetail(_ input: DetailInput) async throws -> PersonEntity {
        do {
            let dto: PersonDTO = try await self.client.request(
                "/person/\(input.id)",
                query: [URLQueryItem(name: "language", value: input.language)]
            )
            return dto.toEntity
        } catch let netErr as NetworkError {
            throw NetworkErrorMapper.toDomain(netErr)
        } catch {
            throw DetailDomainError.unknown
        }
    }
    
    public func fetchCredits(_ input: DetailInput) async throws -> PersonCombineCreditsEntity {
        do {
            let dto: PersonCombineCreditsDTO = try await self.client.request(
                "/person/\(input.id)/combined_credits",
                query: [URLQueryItem(name: "language", value: input.language)]
            )
            return dto.toEntity
        } catch let netErr as NetworkError {
            throw NetworkErrorMapper.toDomain(netErr)
        } catch {
            throw DetailDomainError.unknown
        }
    }
}
