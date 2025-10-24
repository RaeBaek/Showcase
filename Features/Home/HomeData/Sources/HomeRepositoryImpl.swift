//
//  HomeRepositoryImpl.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation
import HomeDomain
import Network

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
        return dto.results.map { $0.toEntity }
    }
    
    func peopleModifyList() async throws -> [ModifyEntity] {
        let dto: ModifyListResponse = try await client.request(
            "/person/changes",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results.map { $0.toEntity }
    }
    
    func tvModifyList() async throws -> [ModifyEntity] {
        let dto: ModifyListResponse = try await client.request(
            "/tv/changes",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results.map { $0.toEntity }
    }
    
    func moviePopularList() async throws -> [PopularMovieEntity] {
        let dto: PopularListResponse<PopularMovieDTO> = try await client.request(
            "/movie/popular",
            query: [
                URLQueryItem(name: "language", value: "ko-KR"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
        return dto.results.map { $0.toEntity }
    }
    
    func peoplePopularList() async throws -> [PopularPeopleEntity] {
        let dto: PopularListResponse<PopularPeopleDTO> = try await client.request(
            "/tv/popular",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results.map { $0.toModify }
    }
    
    func tvPopularList() async throws -> [PopularTVEntity] {
        let dto: PopularListResponse<PopularTVDTO> = try await client.request(
            "/tv/popular",
            query: [URLQueryItem(name: "page", value: "1")]
        )
        return dto.results.map { $0.toModify }
    }
}


 func movieModifyList() async throws -> ModifyListResponse {
     try await self.requestTMDB("/movie/changes", query: [URLQueryItem(name: "page", value: "1")])
 }

 func peopleModifyList() async throws -> ModifyListResponse {
     try await self.requestTMDB("/person/changes", query: [URLQueryItem(name: "page", value: "1")])
 }

 func tvModifyList() async throws -> ModifyListResponse {
     try await self.requestTMDB("/tv/changes", query: [URLQueryItem(name: "page", value: "1")])
 }

 // MARK: 인기 리스트 3종
 func moviePopularList() async throws -> PopularListResponse<PopularMovieDTO> {
     try await self.requestTMDB(
         "/movie/popular",
         query: [
             URLQueryItem(name: "language", value: "ko-KR"),
             URLQueryItem(name: "page", value: "1")
         ]
     )
 }

 func peoplePopularList() async throws -> PopularListResponse<PopularPeopleDTO> {
     try await self.requestTMDB(
         "/person/popular",
         query: [
             URLQueryItem(name: "language", value: "ko-KR"),
             URLQueryItem(name: "page", value: "1")
         ]
     )
 }

 func tvPopularList() async throws -> PopularListResponse<PopularTVDTO> {
     try await self.requestTMDB(
         "/tv/popular",
         query: [
             URLQueryItem(name: "language", value: "ko-KR"),
             URLQueryItem(name: "page", value: "1")
         ]
     )
 }
 
