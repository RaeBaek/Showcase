//
//  HomeRepositoryImpl.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation
import OSLog

import NetworkInterface
import DataInterface

import HomeDomain

public final class HomeRepositoryImpl: HomeRepository {
    private static let logger = Logger(subsystem: "com.raehoon.Showcase.app", category: "HomeNetwork")
    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func moviePopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularMovieEntity> {
        do {
            let dto: PopularListResponse<PopularMovieDTO> = try await requestPopularList("/movie/popular", input: input)
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
            let dto: PopularListResponse<PopularPeopleDTO> = try await requestPopularList("/person/popular", input: input)
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
            let dto: PopularListResponse<PopularTVDTO> = try await requestPopularList("/tv/popular", input: input)
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

    private func requestPopularList<T: Decodable>(_ path: String, input: HomeFeedInput) async throws -> T {
        let query = [
            URLQueryItem(name: "language", value: input.language),
            URLQueryItem(name: "page", value: String(input.page))
        ]
        guard input.page == 1 else {
            return try await client.request(path, query: query)
        }

        Self.logger.info("GET \(path, privacy: .public) started")
        do {
            let response: T = try await client.request(path, query: query)
            Self.logger.info("GET \(path, privacy: .public) succeeded")
            return response
        } catch {
            let cause: Error
            if case let .underlying(underlying)? = error as? NetworkError {
                cause = underlying
            } else {
                cause = error
            }

            let urlError = cause as? URLError
            if Task.isCancelled || cause is CancellationError || urlError?.code == .cancelled {
                Self.logger.info("GET \(path, privacy: .public) cancelled")
            } else {
                let reason: String
                switch cause as? NetworkError {
                case .statusCode(let code):
                    reason = "HTTP status \(code)"
                case .decodingError:
                    reason = "response decoding failed"
                case .timeout:
                    reason = "timed out"
                default:
                    if let urlError {
                        reason = "URLError code \(urlError.code.rawValue)"
                    } else {
                        reason = String(describing: type(of: cause))
                    }
                }
                Self.logger.error("GET \(path, privacy: .public) failed: \(reason, privacy: .public)")
            }
            throw error
        }
    }
}
