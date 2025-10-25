//
//  HomeRepositoryImpl.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation
import Network
import HomeDomain

final class HomeRepositoryImpl: HomeRepository {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func movieModifyList() async throws -> [ModifyEntity] {
        let dto: ModifyListResponse = try await client.request(
            "/movie/changes",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    func peopleModifyList() async throws -> [ModifyEntity] {
        let dto: ModifyListResponse = try await client.request(
            "/person/changes",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    func tvModifyList() async throws -> [ModifyEntity] {
        let dto: ModifyListResponse = try await client.request(
            "/tv/changes",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    func moviePopularList() async throws -> [PopularMovieEntity] {
        let dto: PopularListResponse<PopularMovieDTO> = try await client.request(
            "/movie/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    func peoplePopularList() async throws -> [PopularPeopleEntity] {
        let dto: PopularListResponse<PopularPeopleDTO> = try await client.request(
            "/person/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
    
    func tvPopularList() async throws -> [PopularTVEntity] {
        let dto: PopularListResponse<PopularTVDTO> = try await client.request(
            "/tv/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
        return dto.results?.map { $0.toEntity } ?? []
    }
}
