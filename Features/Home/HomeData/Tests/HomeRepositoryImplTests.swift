//
//  ShowcaseTests.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import XCTest

import NetworkInterface

import HomeData
import HomeDomain

final class HomeRepositoryImplTests: XCTestCase {

    // 간단한 목 클라이언트
    final class MockHTTPClient: HTTPClient {
        var lastPath: String?
        var lastQuery: [URLQueryItem] = []
        var nextResult: Any?
        var nextError: Error?

        func request<T: Decodable>(_ path: String, query: [URLQueryItem]) async throws -> T {
            lastPath = path
            lastQuery = query
            if let error = nextError { throw error }
            guard let value = nextResult as? T else {
                fatalError("nextResult가 \(T.self) 타입이 아닙니다.")
            }
            return value
        }
    }

    func test_moviePopularList_decodesAndMapsToPage() async throws {
        // given
        let mock = MockHTTPClient()
        let repo = HomeRepositoryImpl(client: mock)
        let input = HomeFeedInput(page: 2, language: "ko-KR")

        // TMDB DTO 스텁
        let dto = PopularListResponse<PopularMovieDTO>(
            page: 2,
            results: [
                PopularMovieDTO(
                    adult: false,
                    backdropPath: "/a.jpg",
                    genreIds: [20, 21, 22],
                    id: 231233,
                    originalLanguage: "ko",
                    originalTitle: "어벤져스",
                    overview: "어벤져스가 돌아오다.",
                    popularity: 123.233,
                    posterPath: "/souvvkJHYhztC1UqZ8lEVUiJa3J.jpg",
                    releaseDate: "2024-03-03",
                    title: "어벤져스",
                    video: false,
                    voteAverage: 9.87,
                    voteCount: 213
                )
            ],
            totalPages: 50,
            totalResults: 1000
        )
        mock.nextResult = dto

        // when
        let page: PopularPage<PopularMovieEntity> = try await repo.moviePopularList(input)

        // then: 경로/쿼리 빌드 확인
        XCTAssertEqual(mock.lastPath, "/movie/popular")
        XCTAssertTrue(mock.lastQuery.contains(.init(name: "language", value: "ko-KR")))
        XCTAssertTrue(mock.lastQuery.contains(.init(name: "page", value: "2")))

        // then: 매핑 확인
        XCTAssertEqual(page.page, 2)
        XCTAssertEqual(page.totalPages, 50)
        XCTAssertEqual(page.totalResults, 1000)
        XCTAssertEqual(page.items.count, 1)
        XCTAssertEqual(page.items.first?.id, 231233)
        XCTAssertEqual(page.items.first?.title, "어벤져스")
    }
}
