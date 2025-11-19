//
//  TVDetailRepositoryImplTests.swift
//  DetailDataTests
//
//  Created by 백래훈 on 11/12/25.
//

import XCTest
@testable import DetailDomain
@testable import DetailData

final class TVDetailRepositoryImplTests: XCTestCase {

    var client: MockHTTPClient!
    var sut: TVDetailRepositoryImpl!

    override func setUp() {
        super.setUp()
        client = MockHTTPClient()
        sut = TVDetailRepositoryImpl(client: client)
    }

    override func tearDown() {
        sut = nil
        client = nil
        super.tearDown()
    }

    /// fetchDetail 메서드 및 path, query 일치 decoding 성공 테스트
    func test_fetchDetail_buildCorrectPathAndQuery_andDecodes() async throws {
        // given
        let input = DetailInput(id: 110, language: "ko-KR")
        client.typedDTOs["/tv/\(input.id)"] = makeTVDetailDTO()

        // when
        let entity = try await sut.fetchDetail(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/tv/110")
        XCTAssertEqual(client.captured.first?.query.first?.name, "language")
        XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
        XCTAssertFalse(entity.adult)
        XCTAssertTrue(!entity.inProduction)
        XCTAssertEqual(entity.name, "기묘한 이야기")
    }

    /// fetchDetail 메서드 및 path, query 일치 decoding 성공 테스트
    func test_fetchCredits_buildCorrectPathAndQuery_andDecodes() async throws {
        // given
        let input = DetailInput(id: 120, language: "en-US")
        client.typedDTOs["/tv/\(input.id)/credits"] = makeCreditsDTO()

        // when
        let entity = try await sut.fetchCredits(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/tv/120/credits")
        XCTAssertEqual(client.captured.first?.query.first?.name, "language")
        XCTAssertEqual(client.captured.first?.query.first?.value, "en-US")
        XCTAssertTrue(entity.id == 120)
        XCTAssertTrue(entity.cast.isEmpty)
        XCTAssertFalse(!entity.crew.isEmpty)
    }

    /// fetchVideos 메서드 및 path, qeury 일치 decoding 성공 테스트
    func test_fetchVideos_buildsCorrectPath_andDecodes() async throws {
        // given
        let input = DetailInput(id: 130, language: "ko-KR")
        client.typedDTOs["/tv/\(input.id)/videos"] = makeVideoDTO()

        // when
        let entity = try await sut.fetchVideos(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/tv/130/videos")
        XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
        XCTAssertEqual(entity.id, 130)
        XCTAssertTrue(entity.id == input.id)
        XCTAssertTrue(entity.results.count == 1)
        XCTAssertEqual(entity.results.first?.name, "심슨 가족 1차 예고편")
        XCTAssertTrue(entity.results.first?.official == true)
    }

    /// fetchSimilars 메서드 및 path, qeury 일치 decoding 성공 테스트
    func test_fetchSimilars_buildsCorrectPath_andDecodes() async throws {
        // given
        let input = DetailInput(id: 140, language: "en-US")
        client.typedDTOs["/tv/\(input.id)/similar"] = makeSimilarDTO()

        // when
        let entity = try await sut.fetchSimilars(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/tv/140/similar")
        XCTAssertEqual(client.captured.first?.query.first?.value, "en-US")
        XCTAssertEqual(entity.totalPages, 2)
        XCTAssertEqual(entity.totalResults, 23)
        XCTAssertFalse(entity.results.isEmpty)
        XCTAssertEqual(entity.results.first?.id, 222)
        XCTAssertTrue(entity.results.first?.adult != true)
        XCTAssertNil(entity.results.first?.name)
        XCTAssertNotNil(entity.results.first?.overview)
    }

    /// fetchDetail 메서드 및 path 불일치 에러 테스트
    func test_fetchDetail_buildUncorrectPathAndQuery() async throws {
        // given
        let input = DetailInput(id: 150, language: "ko-KR")
        client.typedDTOs["/tv/160"] = makeTVDetailDTO()

        // when / then
        do {
            let _ = try await sut.fetchDetail(input)
            XCTFail("expected error")
        } catch let error {
            XCTAssertNotNil(client.captured.first?.path)
            XCTAssertNotEqual(client.captured.first?.path, "/tv/160")
            XCTAssertEqual(client.captured.first?.query.first?.name, "language")
            XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
            XCTAssertNil(client.typedDTOs["/tv/\(input.id)"])
            XCTAssert(error is URLError)
        }
    }

    /// fetchVideos 메서드 및 path, query 일치 디코딩 실패 테스트
    func test_fetchVideo_buildCorrectPathAndQuery_andDecodingError() async throws {
        // given
        let input = DetailInput(id: 130, language: "en-US")
        client.typedDTOs["/tv/\(input.id)/videos"] = makeTVDetailDTO()

        // when / then
        do {
            let _ = try await sut.fetchVideos(input)
            XCTFail("expected error")
        } catch let error {
            XCTAssertNotNil(client.captured.first?.path)
            XCTAssertEqual(client.captured.first?.path, "/tv/\(input.id)/videos")
            XCTAssertEqual(client.captured.first?.query.first?.name, "language")
            XCTAssertEqual(client.captured.first?.query.first?.value, "en-US")
            XCTAssertNotNil(client.typedDTOs["/tv/\(input.id)/videos"])
            XCTAssertFalse(client.typedDTOs["/tv/\(input.id)/videos"] is CreditsDTO)
            XCTAssertFalse(client.typedDTOs["/tv/\(input.id)/videos"] is VideoDTO)
            XCTAssertTrue(client.typedDTOs["/tv/\(input.id)/videos"] is TVDetailDTO)
            XCTAssert(error is DecodingError)
        }
    }

    /// 임의의 httpError 에러 발생
    func test_httpError_isPropagated() async {
        // given
        client.error = URLError(.networkConnectionLost)

        // when
        let input = DetailInput(id: 1, language: "en-US")

        // then
        do {
            let _ = try await sut.fetchSimilars(input)
            XCTFail("expected error")
        } catch let error {
            XCTAssertTrue(error is URLError)
            XCTAssertTrue(client.captured.isEmpty)
            XCTAssertTrue(client.typedDTOs.isEmpty)
        }
    }
}

private func makeTVDetailDTO() -> TVDetailDTO {
    return TVDetailDTO(
        adult: false,
        backdropPath: nil,
        createdBy: [],
        episodeRunTime: nil,
        firstAirDate: nil,
        genres: [],
        homepage: nil,
        id: 110,
        inProduction: false,
        languages: nil,
        lastAirDate: nil,
        lastEpisodeToAir: nil,
        name: "기묘한 이야기",
        nextEpisodeToAir: nil,
        networks: [],
        numberOfEpisodes: 0,
        numberOfSeasons: 0,
        originCountry: nil,
        originalLanguage: "",
        originalName: "",
        overview: "",
        popularity: 0,
        posterPath: "",
        productionCompanies: [],
        productionCountries: [],
        seasons: [],
        spokenLanguages: [],
        status: "",
        tagline: nil,
        type: "",
        voteAverage: 0,
        voteCount: 0
    )
}

private func makeCreditsDTO() -> CreditsDTO {
    return CreditsDTO(
        id: 120,
        cast: [],
        crew: []
    )
}

private func makeVideoDTO() -> VideoDTO {
    return VideoDTO(
        id: 130,
        results: [VideoResultDTO(
            iso639_1: "",
            iso3166_1: "",
            name: "심슨 가족 1차 예고편",
            key: "",
            site: "",
            size: 0,
            type: "",
            official: true,
            publishedAt: "",
            id: ""
        )]
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
                id: 222,
                originalCountry: nil,
                originalLanguage: "",
                originalTitle: nil,
                originalName: nil,
                overview: "줄거리...",
                popularity: 0,
                posterPath: nil,
                releaseDate: nil,
                firstAirDate: nil,
                name: nil,
                title: nil,
                video: nil,
                voteAverage: 0,
                voteCount: 0
            )
        ],
        totalPages: 2,
        totalResults: 23
    )
}
