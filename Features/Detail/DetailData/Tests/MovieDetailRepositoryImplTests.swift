//
//  MovieDetailRepositoryImplTests.swift
//  DetailData
//
//  Created by 백래훈 on 11/12/25.
//

import XCTest
@testable import DetailDomain
@testable import DetailData

final class MovieDetailRepositoryImplTests: XCTestCase {

    var client: MockHTTPClient!
    var sut: MovieDetailRepositoryImpl!

    override func setUp() {
        super.setUp()
        client = MockHTTPClient()
        sut = MovieDetailRepositoryImpl(client: client)
    }

    override func tearDown() {
        sut = nil
        client = nil
        super.tearDown()
    }

    /// fetchDetail 메서드 및 path, query 일치 decoding 성공 테스트
    func test_fetchDetail_buildCorrectPathAndQuery_andDecodes() async throws {
        // given
        let input = DetailInput(id: 550, language: "ko-KR")
        client.typedDTOs["/movie/550"] = makeMovieDetailDTO()

        // when
        let entity = try await sut.fetchDetail(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/movie/550")
        XCTAssertEqual(client.captured.first?.query.first?.name, "language")
        XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
        XCTAssertEqual(entity.id, input.id)
        XCTAssertEqual(entity.title, "Avatar")
    }

    /// fetchDetail 메서드 및 path 불일치 에러 테스트
    func test_fetchDetail_buildUncorrectPathAndQuery() async throws {
        // given
        let input = DetailInput(id: 540, language: "ko-KR")
        client.typedDTOs["/movie/550"] = makeMovieDetailDTO()

        // when / then
        do {
            let _ = try await sut.fetchDetail(input)
        } catch let error {
            XCTAssertNotNil(client.captured.first?.path)
            XCTAssertNotEqual(client.captured.first?.path, "/movie/550")
            XCTAssertEqual(client.captured.first?.query.first?.name, "language")
            XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
            XCTAssertNil(client.typedDTOs["/movie/\(input.id)"])
            XCTAssert(error is URLError)
        }
    }

    /// fetchDetail 메서드 및 path, query 일치 디코딩 실패 테스트
    func test_fetchDetail_buildCorrectPathAndQuery_andDecodingError() async throws {
        // given
        let input = DetailInput(id: 550, language: "ko-KR")
        client.typedDTOs["/movie/550"] = makeCreditsDTO()

        // when / then
        do {
            let _ = try await sut.fetchDetail(input)
        } catch let error {
            XCTAssertNotNil(client.captured.first?.path)
            XCTAssertNotEqual(client.captured.first?.path, "/movie/540")
            XCTAssertEqual(client.captured.first?.path, "/movie/550")
            XCTAssertEqual(client.captured.first?.query.first?.name, "language")
            XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
            XCTAssertNotNil(client.typedDTOs["/movie/\(input.id)"])
            XCTAssertFalse(client.typedDTOs["/movie/\(input.id)"] is MovieDetailDTO)
            XCTAssertTrue(client.typedDTOs["/movie/\(input.id)"] is CreditsDTO)
            XCTAssert(error is DecodingError)
        }
    }

    /// fetchCredits 메서드 및 path, query 일치 decoding 성공 테스트
    func test_fetchCredits_buildsCorrectPathAndQuery_andDecodes() async throws {
        // given
        let input = DetailInput(id: 123, language: "ko-KR")
        client.typedDTOs["/movie/123/credits"] = makeCreditsDTO()

        // when
        let entity = try await sut.fetchCredits(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/movie/123/credits")
        XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
        XCTAssertEqual(entity.id, 123)
        XCTAssertTrue(entity.id == input.id)
        XCTAssertTrue(entity.cast.isEmpty)
        XCTAssertFalse(!entity.crew.isEmpty)
    }

    /// fetchVideos 메서드 및 path, qeury 일치 decoding 성공 테스트
    func test_fetchVideos_buildsCorrectPath_andDecodes() async throws {
        // given
        let input = DetailInput(id: 234, language: "ko-KR")
        client.typedDTOs["/movie/234/videos"] = makeVideosDTO()

        // when
        let entity = try await sut.fetchVideos(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/movie/234/videos")
        XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
        XCTAssertEqual(entity.id, 234)
        XCTAssertTrue(entity.id == input.id)
        XCTAssertTrue(entity.results.count == 1)
        XCTAssertEqual(entity.results.first?.name, "1차 예고편")
    }

    /// fetchSimilars 메서드 및 path, qeury 일치 decoding 성공 테스트
    func test_fetchSimilars_buildsCorrectPath_andDecodes() async throws {
        // given
        let input = DetailInput(id: 345, language: "ko-KR")
        client.typedDTOs["/movie/345/similar"] = makeSimilarDTO()

        // when
        let entity = try await sut.fetchSimilars(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/movie/345/similar")
        XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
        XCTAssertEqual(entity.totalPages, 3)
        XCTAssertFalse(entity.results.isEmpty)
        XCTAssertNil(entity.results.first?.name)
        XCTAssertEqual(entity.results.first?.voteCount, 234)
    }

    /// 임의의 httpError 에러 발생
    func test_httpError_isPropagated() async {
        // given
        client.error = URLError(.userAuthenticationRequired)

        // when
        let input = DetailInput(id: 1, language: "ko-KR")

        // then
        do {
            let _ = try await sut.fetchDetail(input)
            XCTFail("expected error")
        } catch let error {
            XCTAssertTrue(error is URLError)
            XCTAssertTrue(client.captured.isEmpty)
            XCTAssertTrue(client.typedDTOs.isEmpty)
        }
    }

}

private func makeMovieDetailDTO() -> MovieDetailDTO {
    return MovieDetailDTO(
        adult: false,
        backdropPath: "",
        belongsToCollection: nil,
        budget: nil,
        genres: [],
        homepage: nil,
        id: 550,
        imdbID: nil,
        originalLanguage: "",
        originalTitle: "",
        overview: "",
        popularity: 10.10,
        posterPath: nil,
        productionCompanies: [],
        productionCountries: [],
        releaseDate: nil,
        revenue: nil,
        runtime: nil,
        spokenLanguages: [],
        status: "",
        tagline: nil,
        title: "Avatar",
        video: true,
        voteAverage: 123.123,
        voteCount: 456
    )
}

private func makeCreditsDTO() -> CreditsDTO {
    return CreditsDTO(
        id: 123,
        cast: [],
        crew: []
    )
}

private func makeVideosDTO() -> VideoDTO {
    return VideoDTO(
        id: 234,
        results: [
            VideoResultDTO(
                iso639_1: "",
                iso3166_1: "",
                name: "1차 예고편",
                key: "",
                site: "",
                size: 5,
                type: "",
                official: true,
                publishedAt: "",
                id: "234"
            )
        ]
    )
}

private func makeSimilarDTO() -> SimilarDTO {
    return SimilarDTO(
        page: 1,
        results: [
            SimilarResultDTO(
                adult: false,
                backdropPath: nil,
                genreIDs: [],
                id: 345,
                originalCountry: nil,
                originalLanguage: "",
                originalTitle: nil,
                originalName: nil,
                overview: "",
                popularity: 43.34,
                posterPath: nil,
                releaseDate: nil,
                firstAirDate: nil,
                name: nil,
                title: nil,
                video: false,
                voteAverage: 78.32,
                voteCount: 234
            )
        ],
        totalPages: 3,
        totalResults: 123
    )
}
