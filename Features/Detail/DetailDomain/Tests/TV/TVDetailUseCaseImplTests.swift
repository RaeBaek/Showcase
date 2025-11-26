//
//  TVDetailUseCaseImplTests.swift
//  DetailDomainTests
//
//  Created by 백래훈 on 11/18/25.
//

import XCTest
@testable import DetailDomain

final class TVDetailUseCaseImplTests: XCTestCase {

    private var repository: MockTVDetailRepository!
    private var useCase: TVDetailUseCaseImpl!

    override func setUp() {
        super.setUp()
        repository = MockTVDetailRepository()
        useCase = TVDetailUseCaseImpl(repository: repository)
    }

    override func tearDown() {
        useCase = nil
        repository = nil
        super.tearDown()
    }

    /// fetchDetail(), DetailInput의 Id와 language가 정상적으로 전달되었는지 테스트
    func test_fetchDetail_buildsInputWithGivenId_andKoreanLanguage() async throws {
        // given
        let id: Int32 = 950
        let detailInput = DetailInput(id: id, language: "ko-KR")
        repository.stubDetail = makeTVDetailEntity(id: id)

        // when
        _ = try await useCase.fetchDetail(detailInput)

        // then
        let input = try XCTUnwrap(repository.detailInputs.first)
        XCTAssertEqual(input.id, id)
        XCTAssertEqual(input.language, "ko-KR")
    }

    /// fetchDetail(), repository에서의 error가 정상적으로 전달되는지 테스트
    func test_fetchDetail_propagatesErrorFromRepository() async throws {
        // given
        let expectedError = URLError(.cannotDecodeContentData)
        repository.error = expectedError

        // when / then
        do {
            let detailInput = DetailInput(id: 1, language: "ko-KR")
            _ = try await useCase.fetchDetail(detailInput)
            XCTFail("Expected error to be thrown")
        } catch let error {
            XCTAssertTrue(error is URLError)
        }
    }

    /// fetchCredits(), DetailInput 체크와 cast.map { $0.toCredit } + crew.map { $0.toCredit } 매핑 검증
    func test_fetchCredits_buildsInputWithKoreanLanguage_andMapToCredit() async throws {
        // given
        let id: Int32 = 1050
        let detailInput = DetailInput(id: id, language: "ko-KR")
        repository.stubCredits = makeCreditsEntity(id: id)

        // when
        let result = try await useCase.fetchCredits(detailInput)

        // then
        let input = try XCTUnwrap(repository.creditsInputs.first)
        XCTAssertEqual(input.id, id)
        XCTAssertEqual(input.language, "ko-KR")

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.id, 333)
        XCTAssertEqual(result.last?.id, 444)
    }

    /// fetchVideos(), DetailInput 체크와 results.map { $0.toVideoItemEntity } 동작 확인
    func test_fetchVideos_buildsInputWithKoreanLanguage_andMapToVideoItemEntity() async throws {
        // given
        let id: Int32 = 1150
        let detailInput = DetailInput(id: id, language: "ko-KR")
        repository.stubVideos = makeVideoEntity(id: id)

        // when
        let result = try await useCase.fetchVideos(detailInput)

        // then
        let input = try XCTUnwrap(repository.videosInputs.first)
        XCTAssertEqual(input.id, id)
        XCTAssertEqual(input.language, "ko-KR")

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.key, "q1w2e3r4")
    }

    /// fetchSimilar(), DetailInput 체크와 results.map { $0.toSimilarMovieItemEntity }
    func test_fetchSimilar_buildsInputWithKoreanLanguage_andMapToSimilarMovieItemEntity() async throws {
        // given
        let id: Int32 = 1250
        let detailInput = DetailInput(id: id, language: "ko-KR")
        repository.stubSimilars = makeSimilarEntity(id: id)

        // when
        let result = try await useCase.fetchSimilars(detailInput)

        // then
        let input = try XCTUnwrap(repository.similarsInputs.first)
        XCTAssertEqual(input.id, id)
        XCTAssertEqual(input.language, "ko-KR")
        XCTAssertEqual(result.count, repository.stubSimilars.results.count)
        XCTAssertEqual(repository.stubSimilars.totalPages, 5)
        XCTAssertEqual(repository.stubSimilars.totalResults, 50)
    }
}

private func makeTVDetailEntity(id: Int32) -> TVDetailEntity {
    return TVDetailEntity(
        adult: false,
        backdropPath: nil,
        createdBy: [],
        episodeRunTime: nil,
        firstAirDate: nil,
        genres: [],
        homepage: nil,
        id: id,
        inProduction: false,
        languages: nil,
        lastAirDate: nil,
        lastEpisodeToAir: nil,
        name: "",
        nextEpisodeToAir: nil,
        networks: [],
        numberOfEpisodes: 0,
        numberOfSeasons: 0,
        originCountry: nil,
        originalLanguage: "",
        originalName: "",
        overview: "",
        popularity: 0,
        posterPath: nil,
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

private func makeCreditsEntity(id: Int32) -> CreditsEntity {
    return CreditsEntity(
        id: Int(id),
        cast: [
            CastEntity(
                adult: true,
                gender: 2,
                id: 333,
                knownForDepartment: nil,
                name: "",
                originalName: "",
                popularity: 0,
                profilePath: nil,
                castID: nil,
                character: nil,
                creditID: "",
                order: nil
            )
        ],
        crew: [
            CrewEntity(
                adult: true,
                gender: 1,
                id: 444,
                knownForDepartment: nil,
                name: "",
                originalName: "",
                popularity: 0,
                profilePath: nil,
                creditID: "",
                department: nil,
                job: nil
            )
        ]
    )
}

private func makeVideoEntity(id: Int32) -> VideoEntity {
    return VideoEntity(
        id: Int(id),
        results: [
            VideoResultEntity(
                iso639_1: "",
                iso3166_1: "",
                name: "",
                key: "q1w2e3r4",
                site: "",
                size: 0,
                type: "",
                official: true,
                publishedAt: "",
                id: ""
            )
        ]
    )
}

private func makeSimilarEntity(id: Int32) -> SimilarEntity {
    return SimilarEntity(
        page: 1,
        results: [
            SimilarResultEntity(
                adult: false,
                backdropPath: nil,
                genreIDs: [],
                id: 0,
                originalCountry: nil,
                originalLanguage: "",
                originalTitle: nil,
                originalName: nil,
                overview: "",
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
        totalPages: 5,
        totalResults: 50
    )
}
