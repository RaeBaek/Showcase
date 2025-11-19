//
//  PeopleDetailViewModelTests.swift
//  DetailPresentationTests
//
//  Created by 백래훈 on 11/18/25.
//

import XCTest
@testable import DetailDomain
@testable import DetailPresentation

@MainActor
final class PeopleDetailViewModelTests: XCTestCase {

    private var useCase: MockPeopleDetailUseCase!
    private var viewModel: PeopleDetailViewModel!

    override func setUp() async throws {
        try await super.setUp()
        useCase = MockPeopleDetailUseCase()

        let id: Int32 = 567

        useCase.stubDetail = makePersonDetailEntity(id: id)
        useCase.stubCredits = makeKnownForItems()

        viewModel = PeopleDetailViewModel(id: id, usecase: useCase)
    }

    override func tearDown() async throws {
        viewModel = nil
        useCase = nil
        try await super.tearDown()
    }

    /// 성공 케이스
    func test_load_success_updatesStateAndProperties() async {
        // given
        XCTAssertEqual(viewModel.peopleDetailState.state, .idle)

        let exp = expectation(description: "loaded state")

        // @Publised peopleDetailState 변경 스트림 구독
        let cancellable = viewModel.$peopleDetailState
            .dropFirst()
            .sink { state in
                if case .loaded = state.state {
                    exp.fulfill()
                }
            }

        // when
        viewModel.load()

        await fulfillment(of: [exp], timeout: 1.0)
        cancellable.cancel()

        // then
        let state = viewModel.peopleDetailState
        if case .loaded = state.state {
            XCTAssertNotNil(state.detail)
            XCTAssertEqual(state.knownFors?.count, useCase.stubCredits.count)
            XCTAssertEqual(state.knownFors?.first?.id, 1)
            XCTAssertEqual(state.knownFors?.last?.id, 2)
        } else {
            XCTFail("Expected state to be .loaded, got \(state.state)")
        }
    }

    /// 실패 케이스
    func test_load_failure_setsFailedState() async {
        // given
        let error = URLError(.badServerResponse)
        useCase.error = error

        let exp = expectation(description: "failed state")

        let cancellable = viewModel.$peopleDetailState
            .dropFirst()
            .sink { state in
                if case .failed = state.state {
                    exp.fulfill()
                }
            }

        // when
        viewModel.load()

        await fulfillment(of: [exp], timeout: 1.0)
        cancellable.cancel()

        // then
        let state = viewModel.peopleDetailState
        switch state.state {
        case .failed(let message):
            XCTAssertTrue(message.contains("오류 -1011"))
        default:
            XCTFail("Expected .failed, got \(state.state)")
        }
    }

    /// 일대기 토글 동작 테스트
    func test_toggleBiographyExpanded_togglesFlag() async {
        // 기본값 false
        XCTAssertFalse(viewModel.peopleDetailState.showFullBio)

        viewModel.toggleOverviewExpanded()
        XCTAssertTrue(viewModel.peopleDetailState.showFullBio)

        viewModel.toggleOverviewExpanded()
        XCTAssertFalse(viewModel.peopleDetailState.showFullBio)
    }
}

private func makePersonDetailEntity(id: Int32) -> PersonDetailEntity {
    return PersonDetailEntity(
        id: id,
        name: "Person 1",
        profilePath: nil,
        knownForDepartment: nil,
        birthday: nil,
        deathday: nil,
        placeOfBirth: nil,
        homepage: nil,
        popularity: 10.0,
        biography: nil
    )
}

private func makeKnownForItems() -> [KnownForItem] {
    return [
        KnownForItem(
            id: 1,
            title: "Item 1",
            posterPath: nil,
            year: nil,
            media: .movie
        ),
        KnownForItem(
            id: 2,
            title: "Item 2",
            posterPath: nil,
            year: nil,
            media: .tv
        )
    ]
}
