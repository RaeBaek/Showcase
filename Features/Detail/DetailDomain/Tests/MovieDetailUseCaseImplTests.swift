//
//  MovieDetailUseCaseImplTests.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/12/25.
//

import XCTest
@testable import DetailDomain

final class MovieDetailUseCaseImplTests: XCTestCase {

    private var repository: MockMovieDetailRepository!
    private var useCase: MovieDetailUseCaseImpl!

    override func setUp() {
        super.setUp()
        repository = MockMovieDetailRepository()
        useCase = MovieDetailUseCaseImpl(repository: repository)
    }

    override func tearDown() {
        useCase = nil
        repository = nil
        super.tearDown()
    }

    /// fetchDetail(), DetailInput의 Id와 language가 정상적으로 전달되었는지 테스트
    func test_fetchDetail_buildsUnputWithGivenId_andKoreanLanguage() async throws {
        // given
        let id: Int32 = 150
        repository.stubDetail = makeMovieDetailEntity(id: id)

        // when
        _ = try await useCase.fetchDetail(id: id)

        // then
        let input = try XCTUnwrap(repository.detailInputs.first)
        XCTAssertEqual(input.id, id)
        XCTAssertEqual(input.language, "ko-KR")
    }

    /// fetchDetail(), repository에서의 error가 정상적으로 전달되는지 테스트
    func test_fetchDetail_propagatesErrorFormRepository() async throws {
        // given
        let expectedError = URLError(.timedOut)
        repository.error = expectedError

        // when / then
        do {
            _ = try await useCase.fetchDetail(id: 1)
            XCTFail("Expected error to be thrown")
        } catch let error {
            XCTAssertTrue(error is URLError)
        }
    }

    /// fetchCredits(), DetailInput 체크와 result 배열 매핑 검증
    func test_fetchCredits_bulidsInputWithKoreanLanguage_andFlattensCastAndCrew() async throws {
        // given
        let id: Int32 = 250
        repository.stubCredits = makeCreditsEntity(id: id)

        // when
        let result = try await useCase.fetchCredits(id: id)

        // then: DetailInput 검증
        let input = try XCTUnwrap(repository.creditsInputs.first)
        XCTAssertEqual(input.id, id)
        XCTAssertEqual(input.language, "ko-KR")

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.id, 350)
        XCTAssertEqual(result.last?.id, 450)
    }

    /// fetchVideo(), DetailInput 체크와 result.map { toVideoItemEntity } 동작 확인
    func test_fetchVideos_buildsInputWithKoreanLanguage_andMoreResults() async throws {
        // given
        let id: Int32 = 550
        repository.stubVideos = makeVideoEntity(id: id)

        // when
        let result = try await useCase.fetchVideos(id: id)

        // then
        let input = try XCTUnwrap(repository.videosInputs.first)
        XCTAssertEqual(input.id, id)
        XCTAssertEqual(input.language, "ko-KR")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "")
        /// results.map { $0.toVideoItemEntity } 정상 동작 확인
        XCTAssertEqual(result.count, repository.stubVideos.results.count)
    }

    /// fetchSimilar(), DetailInput 체크와 result.map { $0.toSimilarMovieItemEntity } 동작 확인
    func test_fetchSimilar_buildsInputWithKoreanLanguage_andMapsResults() async throws {
        // given
        let id: Int32 = 650
        repository.stubSimilars = makeSimilarEntity(id: id)

        // when
        let result = try await useCase.fetchSimilar(id: id)

        // then
        let input = try XCTUnwrap(repository.similarsInputs.first)
        XCTAssertEqual(input.id, id)
        XCTAssertEqual(input.language, "ko-KR")
        XCTAssertEqual(result.count, repository.stubSimilars.results.count)
        XCTAssertEqual(repository.stubSimilars.totalPages, 3)
        XCTAssertEqual(repository.stubSimilars.totalResults, 30)
    }
}

private func makeMovieDetailEntity(id: Int32) -> MovieDetailEntity {
    return MovieDetailEntity(
        adult: false,
        backdropPath: "",
        belongsToCollection: nil,
        budget: nil,
        genres: [],
        homepage: nil,
        id: id,
        imdbID: nil,
        originalLanguage: "en-US",
        originalTitle: "",
        overview: "",
        popularity: 0,
        posterPath: "",
        productionCompanies: [],
        productionCountries: [],
        releaseDate: nil,
        revenue: nil,
        runtime: nil,
        spokenLanguages: [],
        status: "",
        tagline: nil,
        title: "",
        video: false,
        voteAverage: 0,
        voteCount: 0
    )
}

private func makeCreditsEntity(id: Int32) -> CreditsEntity {
    return CreditsEntity(
        id: Int(id),
        cast: [CastEntity(
            adult: false,
            gender: nil,
            id: 350,
            knownForDepartment: nil,
            name: "",
            originalName: "",
            popularity: 0,
            profilePath: "",
            castID: nil,
            character: nil,
            creditID: "",
            order: nil
        )],
        crew: [CrewEntity(
            adult: false,
            gender: nil,
            id: 450,
            knownForDepartment: nil,
            name: "",
            originalName: "",
            popularity: 0,
            profilePath: nil,
            creditID: "",
            department: nil,
            job: nil
        )]
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
                key: "",
                site: "",
                size: 0,
                type: "",
                official: false,
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
                id: 5,
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
        totalPages: 3,
        totalResults: 30
    )
}
