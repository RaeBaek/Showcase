//
//  PeopleDetailUseCaseImplTests.swift
//  DetailDomainTests
//
//  Created by 백래훈 on 11/18/25.
//

import XCTest
@testable import DetailDomain

final class PeopleDetailUseCaseImplTests: XCTestCase {

    private var repository: MockPeopleDetailRepository!
    private var useCase: PeopleDetailUseCaseImpl!

    override func setUp() {
        super.setUp()
        repository = MockPeopleDetailRepository()
        useCase = PeopleDetailUseCaseImpl(repository: repository)
    }

    override func tearDown() {
        useCase = nil
        repository = nil
        super.tearDown()
    }

    /// fetchDetail(), DetailInput의 Id와 language가 정상적으로 전달되었는지 테스트
    func test_fetchDetail_buildInputWithGivenID_andKoreanLanguage() async throws {
        // given
        let id: Int32 = 650
        let detailInput = DetailInput(id: id, language: "ko-KR")
        repository.stubPerson = makePersonEntity(id: id)

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
        let expectedError = URLError(.badServerResponse)
        repository.error = expectedError

        // when / then
        do {
            let detailInput = DetailInput(id: 3, language: "ko-KR")
            _ = try await useCase.fetchDetail(detailInput)
            XCTFail("Expected error to be thrown")
        } catch let error {
            XCTAssertTrue(error is URLError)
        }
    }

    /// fetchCredits(), DetailInput 체크와 (cast + crew).toKnownForItems() 매핑 검증
    func test_fetchCredits_buildsInputWithKoreanLanguage_andMappingToKnownForItems() async throws {
        // given
        let id: Int32 = 750
        let detailInput = DetailInput(id: id, language: "ko-KR")
        repository.stubPersonCombineCredits = makePersonCombineCreditsEntity(id: id)

        // when
        let result = try await useCase.fetchCredits(detailInput)

        print(result)

        // then
        let input = try XCTUnwrap(repository.creditsInputs.first)

        XCTAssertEqual(input.id, id)
        XCTAssertEqual(input.language, "ko-KR")

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.id, 1234)
        XCTAssertEqual(result.last?.id, 2345)
    }

    /// fetchCredits(), repository에서의 error가 정상적으로 전달되는지 테스트
    func test_fetchCredits_propagatesErrorFromRepository() async throws {
        // given
        let expectedError = URLError(.networkConnectionLost)
        repository.error = expectedError

        // when / then
        do {
            let detailInput = DetailInput(id: 5, language: "ko-KR")
            _ = try await useCase.fetchCredits(detailInput)
            XCTFail("Expected error to be thrown")
        } catch let error {
            XCTAssertTrue(error is URLError)
        }
    }

}

private func makePersonEntity(id: Int32) -> PersonEntity {
    return PersonEntity(
        adult: true,
        alsoKnownAs: [],
        biography: "",
        birthday: nil,
        deathday: nil,
        gender: 2,
        homepage: nil,
        id: id,
        imdbID: nil,
        knownForDepartment: "",
        name: "",
        placeOfBirth: nil,
        popularity: 0,
        profilePath: nil
    )
}

private func makePersonCombineCreditsEntity(id: Int32) -> PersonCombineCreditsEntity {
    return PersonCombineCreditsEntity(
        id: Int(id),
        cast: [
            PersonCreditEntity(
                adult: true,
                backdropPath: nil,
                genreIDs: nil,
                id: 1234,
                originalLanguage: "",
                overview: "",
                popularity: 0,
                posterPath: nil,
                character: nil,
                voteAverage: nil,
                voteCount: nil,
                creditID: "",
                department: nil,
                job: nil,
                mediaType: .movie,
                title: "",
                originalTitle: nil,
                releaseDate: "2020-04-04",
                video: nil,
                order: nil,
                name: nil,
                originalName: nil,
                firstAirDate: nil,
                originCountry: nil,
                episodeCount: nil,
                firstCreditAirDate: nil
            )
        ],
        crew: [
            PersonCreditEntity(
                adult: true,
                backdropPath: nil,
                genreIDs: nil,
                id: 2345,
                originalLanguage: "",
                overview: "",
                popularity: 0,
                posterPath: nil,
                character: nil,
                voteAverage: nil,
                voteCount: nil,
                creditID: "",
                department: nil,
                job: nil,
                mediaType: .tv,
                title: nil,
                originalTitle: nil,
                releaseDate: nil,
                video: nil,
                order: nil,
                name: "",
                originalName: nil,
                firstAirDate: nil,
                originCountry: nil,
                episodeCount: nil,
                firstCreditAirDate: "2021-04-04"
            )
        ]
    )
}
