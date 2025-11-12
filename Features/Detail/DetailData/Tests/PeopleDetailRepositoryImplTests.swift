//
//  PeopleDetailRepositoryImplTests.swift
//  DetailDataTests
//
//  Created by 백래훈 on 11/12/25.
//

import XCTest
@testable import DetailDomain
@testable import DetailData

final class PeopleDetailRepositoryImplTests: XCTestCase {

    var client: MockHTTPClient!
    var sut: PeopleDetailRepositoryImpl!

    override func setUp() {
        super.setUp()
        client = MockHTTPClient()
        sut = PeopleDetailRepositoryImpl(client: client)
    }

    override func tearDown() {
        sut = nil
        client = nil
        super.tearDown()
    }

    /// fetchDetail 메서드 및 path, query 일치 decoding 성공 테스트
    func test_fetchDetail_buildCorrectPathAndQuery_andDecodes() async throws {
        // given
        let input = DetailInput(id: 123, language: "ko-KR")
        client.typedDTOs["/person/\(input.id)"] = makePersonDTO()

        // when
        let entity = try await sut.fetchDetail(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/person/123")
        XCTAssertEqual(client.captured.first?.query.first?.name, "language")
        XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
        XCTAssertEqual(entity.id, input.id)
        XCTAssertEqual(entity.name, "홍길동")

    }

    /// fetchCredits 메서드 및 path, query 일치 decoding 성공 테스트
    func test_fetchCredits_buildCorrectPathAndQuery_andDecodes() async throws {
        // given
        let input = DetailInput(id: 234, language: "en-US")
        client.typedDTOs["/person/\(input.id)/combined_credits"] = makePersonCombineCredits()

        // when
        let entity = try await sut.fetchCredits(input)

        // then
        XCTAssertEqual(client.captured.first?.path, "/person/234/combined_credits")
        XCTAssertEqual(client.captured.first?.query.first?.name, "language")
        XCTAssertEqual(client.captured.first?.query.first?.value, "en-US")
        XCTAssertEqual(Int32(entity.id), input.id)
        XCTAssertTrue(entity.cast.isEmpty)
        XCTAssertFalse(!entity.crew.isEmpty)
    }

    /// fetchDetail 메서드 및 path 불일치 에러 테스트
    func test_fetchDetail_buildUncorrectPathAndQuery() async throws {
        // given
        let input = DetailInput(id: 345, language: "ko-KR")
        client.typedDTOs["/person/346"] = makePersonDTO()

        // when / then
        do {
            let _ = try await sut.fetchDetail(input)
            XCTFail("expected error")
        } catch let error {
            XCTAssertEqual(client.captured.first?.path, "/person/345")
            XCTAssertNotEqual(client.captured.first?.path, "/movie/346")
            XCTAssertEqual(client.captured.first?.query.first?.name, "language")
            XCTAssertEqual(client.captured.first?.query.first?.value, "ko-KR")
            XCTAssertNil(client.typedDTOs["/person/\(input.id)"])
            XCTAssertNotNil(client.typedDTOs["/person/346"])
            XCTAssert(error is URLError)
        }
    }

    /// fetchCredits 메서드 및 path, query 일치 디코딩 실패 테스트
    func test_fetchCredits_buildCorrectPathAndQuery_andDecodingError() async throws {
        // given
        let input = DetailInput(id: 234, language: "en-US")
        client.typedDTOs["/person/\(input.id)/combined_credits"] = makePersonCombineCredits()

        // when / then
        do {
            let _ = try await sut.fetchCredits(input)
        } catch let error {
            XCTFail("expected error")
            XCTAssertNotNil(client.captured.first?.path)
            XCTAssertNotEqual(client.captured.first?.path, "/person/547/combined_credits")
            XCTAssertEqual(client.captured.first?.path, "/person/234/combined_credits")
            XCTAssertEqual(client.captured.first?.query.first?.name, "language")
            XCTAssertEqual(client.captured.first?.query.first?.value, "en-US")
            XCTAssertNotNil(client.typedDTOs["/person/\(input.id)/combined_credits"])
            XCTAssertFalse(client.typedDTOs["/person/\(input.id)/combined_credits"] is PersonDTO)
            XCTAssertTrue(client.typedDTOs["/person/\(input.id)/combined_credits"] is PersonCombineCreditsDTO)
            XCTAssert(error is DecodingError)
        }
    }

    /// 임의의 httpError 에러 발생
    func test_fetchCredits_httpError_isPropagated() async throws {
        // given
        client.error = URLError(.badServerResponse)

        // when
        let iuput = DetailInput(id: 1, language: "ko-KR")

        // then
        do {
            let _ = try await sut.fetchCredits(iuput)
            XCTFail("expected error")
        } catch let error {
            XCTAssertTrue(error is URLError)
            XCTAssertTrue(client.captured.isEmpty)
            XCTAssertTrue(client.typedDTOs.isEmpty)
        }
    }
}

private func makePersonDTO() -> PersonDTO {
    return PersonDTO(
        adult: true,
        alsoKnownAs: [],
        biography: "일대기가 업습니다.",
        birthday: nil,
        deathday: nil,
        gender: 2,
        homepage: nil,
        id: 123,
        imdbID: nil,
        knownForDepartment: "",
        name: "홍길동",
        placeOfBirth: nil,
        popularity: 0,
        profilePath: nil
    )
}

private func makePersonCombineCredits() -> PersonCombineCreditsDTO {
    return PersonCombineCreditsDTO(
        id: 234,
        cast: [],
        crew: []
    )
}
