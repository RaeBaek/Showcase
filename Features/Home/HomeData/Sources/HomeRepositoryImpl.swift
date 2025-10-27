//
//  HomeRepositoryImpl.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation
import ShowNetwork
import HomeDomain

public final class HomeRepositoryImpl: HomeRepository {
    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func movieModifyList() async throws -> [ModifyEntity] {
        let dto: ModifyListResponse = try await self.client.request(
            "/movie/changes",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    public func peopleModifyList() async throws -> [ModifyEntity] {
        let dto: ModifyListResponse = try await self.client.request(
            "/person/changes",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    public func tvModifyList() async throws -> [ModifyEntity] {
        let dto: ModifyListResponse = try await self.client.request(
            "/tv/changes",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    public func moviePopularList() async throws -> [PopularMovieEntity] {
        let dto: PopularListResponse<PopularMovieDTO> = try await self.client.request(
            "/movie/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    public func peoplePopularList() async throws -> [PopularPeopleEntity] {
        let dto: PopularListResponse<PopularPeopleDTO> = try await self.client.request(
            "/person/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    public func tvPopularList() async throws -> [PopularTVEntity] {
        let dto: PopularListResponse<PopularTVDTO> = try await self.client.request(
            "/tv/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
}
