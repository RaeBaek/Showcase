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
                    adult: true,
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

    func test_peoplePopularList_decodesAndMapsToPage() async throws {
        // given
        let mock = MockHTTPClient()
        let repo = HomeRepositoryImpl(client: mock)
        let input = HomeFeedInput(page: 2, language: "ko-KR")

        // TMDB DTO 스텁
        let dto = PopularListResponse<PopularPeopleDTO>(
            page: 2,
            results: [
                PopularPeopleDTO(
                    adult: true,
                    gender: 1,
                    id: 323342,
                    knownFor: [
                        KnownForDTO(
                            adult: true,
                            backdropPath: "/ilRyazdMJwN05exqhwK4tMKBYZs.jpg",
                            genreIDs: [878, 18],
                            id: 335984,
                            mediaType: "movie",
                            originalLanguage: "en",
                            originalTitle: "Blade Runner 2049",
                            overview: "Thirty years after the events of the first film",
                            posterPath: "/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg",
                            releaseDate: "2017-10-04",
                            title: "Blade Runner 2049",
                            video: false,
                            voteAverage: 7.5,
                            voteCount: 11771
                        )
                    ],
                    knownForDepartment: "Acting",
                    name: "Rufus Sewell",
                    popularity: 102.157,
                    profilePath: "/yc2EWyg45GO03YqDttaEhjvegiE.jpg"
                )
            ],
            totalPages: 150,
            totalResults: 1500
        )
        mock.nextResult = dto

        // when
        let page: PopularPage<PopularPeopleEntity> = try await repo.peoplePopularList(input)

        // then: 경로/쿼리 빌드 확인
        XCTAssertEqual(mock.lastPath, "/person/popular")
        XCTAssertTrue(mock.lastQuery.contains(.init(name: "language", value: "ko-KR")))
        XCTAssertTrue(mock.lastQuery.contains(.init(name: "page", value: "2")))

        // then: 매핑 확인
        XCTAssertEqual(page.page, 2)
        XCTAssertEqual(page.totalPages, 150)
        XCTAssertEqual(page.totalResults, 1500)
        XCTAssertEqual(page.items.count, 1)
        XCTAssertEqual(page.items.first?.knownFor?.first?.adult, true)
        XCTAssertEqual(page.items.first?.knownForDepartment, "Acting")
    }

    func test_tvPopularList_decodesAndMapsToPage() async throws {
        // given
        let mock = MockHTTPClient()
        let repo = HomeRepositoryImpl(client: mock)
        let input = HomeFeedInput(page: 2, language: "ko-KR")

        // TMDB DTO 스텁
        let dto = PopularListResponse<PopularTVDTO>(
            page: 2,
            results: [
                PopularTVDTO(
                    adult: true,
                    backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
                    genreIDs: [9648, 18],
                    id: 202250,
                    originCountry: ["PH"],
                    originalLanguage: "tl",
                    originalName: "Dirty Linen",
                    overview: "To exact vengeance",
                    popularity: 2797.914,
                    posterPath: "/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg",
                    firstAirDate: "2023-01-23",
                    name: "Dirty Linen",
                    voteAverage: 5,
                    voteCount: 13
                )
            ],
            totalPages: 150,
            totalResults: 1500
        )
        mock.nextResult = dto

        // when
        let page: PopularPage<PopularTVEntity> = try await repo.tvPopularList(input)

        // then: 경로/쿼리 빌드 확인
        XCTAssertEqual(mock.lastPath, "/tv/popular")
        XCTAssertTrue(mock.lastQuery.contains(.init(name: "language", value: "ko-KR")))
        XCTAssertTrue(mock.lastQuery.contains(.init(name: "page", value: "2")))

        // then: 매핑 확인
        XCTAssertEqual(page.page, 2)
        XCTAssertEqual(page.totalPages, 150)
        XCTAssertEqual(page.totalResults, 1500)
        XCTAssertEqual(page.items.count, 1)
        XCTAssertEqual(page.items.first?.genreIDs?.first, 9648)
        XCTAssertEqual(page.items.first?.voteCount, 13)
    }

    func test_moviePopularList_propagatesHTTPError() async {
        // given
        enum StubError: Error { case network }
        let mock = MockHTTPClient()
        let repo = HomeRepositoryImpl(client: mock)
        mock.nextError = StubError.network

        // when / then
        do {
            let _ = try await repo.moviePopularList(.init(page: 1, language: "ko-KR"))
            XCTFail("Expected to throw, but succeeded")
        } catch {
            // success: error propagated
            XCTAssertTrue(error is StubError)
        }
    }

    func test_peoplePopularList_propagatesDecodingError() async {
        // given: 클라이언트 계층에서 발생하는 디코딩 에러를 전달받는지 검증
        let mock = MockHTTPClient()
        let repo = HomeRepositoryImpl(client: mock)
        let decodingError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "stub decoding error"))
        mock.nextError = decodingError

        // when / then
        do {
            let _ = try await repo.peoplePopularList(.init(page: 1, language: "ko-KR"))
            XCTFail("Expected to throw, but succeeded")
        } catch {
            XCTAssertTrue(error is DecodingError)
            print("Error: \(error)")
        }
    }

    func test_tvPopularList_nilResults_mapsToEmptyItems() async throws {
        // given: results == nil -> 빈 배열 매핑
        let mock = MockHTTPClient()
        let repo = HomeRepositoryImpl(client: mock)
        let dto = PopularListResponse<PopularTVDTO>(
            page: 3,
            results: nil,
            totalPages: 10,
            totalResults: 100
        )
        mock.nextResult = dto

        // when
        let page: PopularPage<PopularTVEntity> = try await repo.tvPopularList(.init(page: 3, language: "ko-KR"))

        // then
        XCTAssertEqual(page.page, 3)
        XCTAssertEqual(page.totalPages, 10)
        XCTAssertEqual(page.totalResults, 100)
        XCTAssertEqual(page.items.count, 0)
    }

    func test_moviePopularList_buildsCorrectPathAndQuery_evenOnError() async throws {
        // given: 에러가 나더라도 path/query는 올바르게 세팅되어야 함
        enum StubError: Error { case network }
        let mock = MockHTTPClient()
        let repo = HomeRepositoryImpl(client: mock)
        let input = HomeFeedInput(page: 42, language: "ja-JP")
        mock.nextError = StubError.network

        do {
            // when
            let _: PopularPage<PopularMovieEntity> = try await repo.moviePopularList(input)
        } catch {
            // then
            XCTAssertEqual(mock.lastPath, "/movie/popular")
            XCTAssertTrue(mock.lastQuery.contains(.init(name: "language", value: "ja-JP")))
            XCTAssertTrue(mock.lastQuery.contains(.init(name: "page", value: "42")))
        }
    }
}
