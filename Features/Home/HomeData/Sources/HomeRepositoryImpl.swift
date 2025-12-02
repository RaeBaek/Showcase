//
//  HomeRepositoryImpl.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

import NetworkInterface
import DataInterface

import HomeDomain

public final class HomeRepositoryImpl: HomeRepository {
    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    //    public func movieModifyList() async throws -> [ModifyEntity] {
    //        let dto: ModifyListResponse = try await self.client.request(
    //            "/movie/changes",
    //            query: [URLQueryItem(name: "page", value: "1")]
    //        )
    //        return dto.results?.map { $0.toEntity } ?? []
    //    }
    //
    //    public func peopleModifyList() async throws -> [ModifyEntity] {
    //        let dto: ModifyListResponse = try await self.client.request(
    //            "/person/changes",
    //            query: [URLQueryItem(name: "page", value: "1")]
    //        )
    //        return dto.results?.map { $0.toEntity } ?? []
    //    }
    //
    //    public func tvModifyList() async throws -> [ModifyEntity] {
    //        let dto: ModifyListResponse = try await self.client.request(
    //            "/tv/changes",
    //            query: [URLQueryItem(name: "page", value: "1")]
    //        )
    //        return dto.results?.map { $0.toEntity } ?? []
    //    }

    public func moviePopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularMovieEntity> {
        do {
            let dto: PopularListResponse<PopularMovieDTO> = try await self.client.request(
                "/movie/popular",
                query: [
                    URLQueryItem(name: "language", value: input.language),
                    URLQueryItem(name: "page", value: String(input.page))
                ]
            )
            let items = dto.results?.map { $0.toEntity } ?? []

            return PopularPage(
                items: items,
                page: dto.page ?? input.page,
                totalPages: dto.totalPages ?? input.page,
                totalResults: dto.totalResults ?? items.count
            )
        } catch let netErr as NetworkError {
            throw NetworkErrorMapper.toDomain(netErr)
        } catch {
            throw HomeDomainError.unknown
        }
    }

    public func peoplePopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularPeopleEntity> {
        do {
            let dto: PopularListResponse<PopularPeopleDTO> = try await self.client.request(
                "/person/popular",
                query: [
                    URLQueryItem(name: "language", value: input.language),
                    URLQueryItem(name: "page", value: String(input.page))
                ]
            )
            let items = dto.results?.map { $0.toEntity } ?? []
            return PopularPage(
                items: items,
                page: dto.page ?? input.page,
                totalPages: dto.totalPages ?? input.page,
                totalResults: dto.totalResults ?? items.count
            )
        } catch let netErr as NetworkError {
            throw NetworkErrorMapper.toDomain(netErr)
        } catch {
            throw HomeDomainError.unknown
        }
    }

    public func tvPopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularTVEntity> {
        do {
            let dto: PopularListResponse<PopularTVDTO> = try await self.client.request(
                "/tv/popular",
                query: [
                    URLQueryItem(name: "language", value: input.language),
                    URLQueryItem(name: "page", value: String(input.page))
                ]
            )
            let items = dto.results?.map { $0.toEntity } ?? []
            return PopularPage(
                items: items,
                page: dto.page ?? input.page,
                totalPages: dto.totalPages ?? input.page,
                totalResults: dto.totalResults ?? items.count
            )
        } catch let netErr as NetworkError {
            throw NetworkErrorMapper.toDomain(netErr)
        } catch {
            throw HomeDomainError.unknown
        }
    }
}
