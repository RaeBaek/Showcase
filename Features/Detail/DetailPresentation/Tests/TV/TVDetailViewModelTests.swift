//
//  TVDetailViewModelTests.swift
//  DetailPresentationTests
//
//  Created by 백래훈 on 11/18/25.
//

import XCTest
@testable import DetailDomain
@testable import DetailPresentation
import Combine

@MainActor
final class TVDetailViewModelTests: XCTestCase {

    private var useCase: MockTVDetailUseCase!
    private var viewModel: TVDetailViewModel!

    override func setUp() async throws {
        try await super.setUp()
        useCase = MockTVDetailUseCase()

        let id: Int32 = 789

        useCase.stubDetail = makeTVDetailInfoEntity(id: id)
        useCase.stubCredits = makeCreditInfoEntitys()
        useCase.stubVideos = makeVideoItemEntitys()
        useCase.stubSimilars = makeSimilarItemEntitys()

        viewModel = TVDetailViewModel(
            id: id,
            language: useCase.language,
            useCase: useCase
        )
    }

    override func tearDown() async throws {
        viewModel = nil
        useCase = nil
        try await super.tearDown()
    }

    /// 성공 케이스
    func test_load_success_updatesStateAndProperties() async {
        // given
        XCTAssertEqual(viewModel.tvDetailState.state, .idle)

        let exp = expectation(description: "loaded state")

        // @Publised tvDetailState 변경 스트림 구독
        let cancellable = viewModel.$tvDetailState
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

        // then: UseCase 호출 횟수
        XCTAssertEqual(useCase.fetchDetailCallCount, 1)
        XCTAssertEqual(useCase.fetchCreditsCallCount, 1)
        XCTAssertEqual(useCase.fetchVideosCallCount, 1)
        XCTAssertEqual(useCase.fetchSimilarsCallCount, 1)

        // then: 상태 값 검증
        let state = viewModel.tvDetailState
        if case .loaded = state.state {
            // state 내부 값들이 모두 채워졌는지
            XCTAssertNotNil(state.adater)
            XCTAssertEqual(state.credits.count, useCase.stubCredits.count)
            XCTAssertEqual(state.videos.count, useCase.stubVideos.count)
            XCTAssertEqual(state.similars.count, useCase.stubSimilars.count)
        } else {
            XCTFail("Expected state to be .loaded, got \(state.state)")
        }
    }

    /// 실패 케이스
    func test_load_failure_setsFailedState() async {
        // given
        let error = URLError(.notConnectedToInternet)
        useCase.error = error

        let exp = expectation(description: "failed state")
        var cancellables = Set<AnyCancellable>()

        viewModel.$tvDetailState
            .sink { state in
                if case .failed = state.state {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        // when
        viewModel.load()

        await fulfillment(of: [exp], timeout: 5.0)

        // then
        let state = viewModel.tvDetailState
        switch state.state {
        case .failed(let message):
            XCTAssertTrue(message.contains("오류 -1009"))
        default:
            XCTFail("Expected .failed, got \(state.state)")
        }
    }

    /// 개요 토글 동작 테스트
    func test_toggleOverviewExpanded_toggleFlag() async {
        // 기본값 false
        XCTAssertFalse(viewModel.tvDetailState.showFullOverview)

        viewModel.toggleOverviewExpanded()
        XCTAssertTrue(viewModel.tvDetailState.showFullOverview)

        viewModel.toggleOverviewExpanded()
        XCTAssertFalse(viewModel.tvDetailState.showFullOverview)
    }
}

private func makeTVDetailInfoEntity(id: Int32) -> TVDetailInfoEntity {
    return TVDetailInfoEntity(
        id: id,
        name: "",
        originalName: nil,
        tagline: nil,
        posterPath: nil,
        backdropPath: nil,
        firstAirDate: nil,
        lastAirDate: nil,
        status: "",
        inProduction: false,
        numberOfSeasons: 0,
        numberOfEpisodes: 0,
        episodeRunTime: nil,
        createdBy: [],
        networks: [],
        homepage: nil,
        overview: "",
        genres: [],
        originCountry: nil,
        originalLanguage: "",
        voteAverage: 10.1,
        voteCount: 0
    )
}

private func makeCreditInfoEntitys() -> [CreditInfoEntity] {
    return [
        CreditInfoEntity(
            id: 1,
            name: "",
            role: nil,
            profileURL: nil
        ),
        CreditInfoEntity(
            id: 2,
            name: "",
            role: nil,
            profileURL: nil
        )
    ]
}

private func makeVideoItemEntitys() -> [VideoItemEntity] {
    return [
        VideoItemEntity(
            id: "3",
            name: "",
            site: "",
            key: "",
            type: ""
        ),
        VideoItemEntity(
            id: "4",
            name: "",
            site: "",
            key: "",
            type: ""
        )
    ]
}

private func makeSimilarItemEntitys() -> [SimilarItemEntity] {
    return [
        SimilarItemEntity(
            id: 5,
            title: nil,
            posterURL: nil
        ),
        SimilarItemEntity(
            id: 6,
            title: nil,
            posterURL: nil
        )
    ]
}
