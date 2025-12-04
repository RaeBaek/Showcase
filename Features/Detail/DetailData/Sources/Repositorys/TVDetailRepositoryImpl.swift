//
//  TVDetailRepositoryImpl.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

import NetworkInterface

import DataInterface

import DetailDomain

public final class TVDetailRepositoryImpl: TVDetailRepository {

    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func fetchDetail(_ input: DetailInput) async throws -> TVDetailEntity {
        do {
            let dto: TVDetailDTO = try await client.request(
                "/tv/\(input.id)",
                query: [URLQueryItem(name: "language", value: input.language)]
            )
            return dto.toEntity
        } catch let netErr as NetworkError {
            throw NetworkErrorMapper.toDomain(netErr)
        } catch {
            throw DetailDomainError.unknown
        }
    }

    public func fetchCredits(_ input: DetailInput) async throws -> CreditsEntity {
        do {
            let dto: CreditsDTO = try await client.request(
                "/tv/\(input.id)/credits",
                query: [URLQueryItem(name: "language", value: input.language)]
            )
            return dto.toEntity
        } catch let netErr as NetworkError {
            throw NetworkErrorMapper.toDomain(netErr)
        } catch {
            throw DetailDomainError.unknown
        }
    }

    public func fetchVideos(_ input: DetailInput) async throws -> VideoEntity {
        do {
            let dto: VideoDTO = try await client.request(
                "/tv/\(input.id)/videos",
                query: [URLQueryItem(name: "language", value: input.language)]
            )
            return dto.toEntity
        } catch let netErr as NetworkError {
            throw NetworkErrorMapper.toDomain(netErr)
        } catch {
            throw DetailDomainError.unknown
        }
    }

    public func fetchSimilars(_ input: DetailInput) async throws -> SimilarEntity {
        do {
            let dto: SimilarDTO = try await client.request(
                "/tv/\(input.id)/similar",
                query: [
                    URLQueryItem(name: "language", value: input.language),
                    URLQueryItem(name: "page", value: "\(input.page)")
                ]
            )
            return dto.toEntity
        } catch let netErr as NetworkError {
            throw NetworkErrorMapper.toDomain(netErr)
        } catch {
            throw DetailDomainError.unknown
        }
    }
}
