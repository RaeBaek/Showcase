//
//  MovieDetailViewModelTests.swift
//  DetailPresentationTests
//
//  Created by 백래훈 on 11/12/25.
//

import XCTest
@testable import DetailDomain
@testable import DetailPresentation

@MainActor
final class MovieDetailViewModelTests: XCTestCase {

    private var useCase: MockMovieDetailUseCase!
    private var viewModel: MovieDetailViewModel!

    override func setUp() async throws {
        try await super.setUp()
        useCase = MockMovieDetailUseCase()

        let id: Int32 = 456

        useCase.stubDetail = makeMovieDetailInfoEntity(id: id)
        useCase.stubCredits = makeCreditInfoEntitys()
        useCase.stubVideos = makeVideoItemEntitys()
        useCase.stubSimilar = makeSimilarItemEntitys()

        viewModel = MovieDetailViewModel(id: id, useCase: useCase)
    }

    override func tearDown() async throws {
        viewModel = nil
        useCase = nil
        try await super.tearDown()
    }

    /// 성공 케이스
    func test_load_success_updatesStateAndProperties() async {
        // given
        XCTAssertEqual(viewModel.movieDetailState.state, .idle)

        let exp = expectation(description: "loaded state")

        // @Published movieDetailState 변경 스트림 구독
        let cancellable = viewModel.$movieDetailState
            .dropFirst() // .idle -> 다음부터
            .sink { state in
                if case .loaded = state.state {
                    exp.fulfill()
                }
            }

        // when
        viewModel.load()

//        await wait(for: [exp], timeout: 1.0)
        await fulfillment(of: [exp], timeout: 1.0)
        cancellable.cancel()

        // then: UseCase 호출 횟수
        XCTAssertEqual(useCase.fetchDetailCallCount, 1)
        XCTAssertEqual(useCase.fetchCreditsCallCount, 1)
        XCTAssertEqual(useCase.fetchVideosCallCount, 1)
        XCTAssertEqual(useCase.fetchSimilarCallCount, 1)

        // then: 상태 값 검증
        let state = viewModel.movieDetailState
        if case .loaded = state.state {
            // state 내부 값들이 모두 채워졌는지
            XCTAssertNotNil(state.adapter)
            XCTAssertEqual(state.credits.count, useCase.stubCredits.count)
            XCTAssertEqual(state.videos.count, useCase.stubVideos.count)
            XCTAssertEqual(state.similars.count, useCase.stubSimilar.count)
        } else {
            XCTFail("Expected state to be .loaded, got \(state.state)")
        }
    }

    /// 실패 케이스
    func test_load_failure_setsFailedState() async {
        // given
        let error = URLError(.cannotLoadFromNetwork)
        useCase.error = error

        let exp = expectation(description: "failed state")

        let cancellable = viewModel.$movieDetailState
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
        let state = viewModel.movieDetailState
        switch state.state {
        case .failed(let message):
            XCTAssertTrue(message.contains("오류 -2000"))
        default:
            XCTFail("Expected .failed, got \(state.state)")
        }
    }

    /// 개요 토글 동작 테스트
    func test_toggleOverviewExpanded_togglesFlag() async {
        // 기본값 false
        XCTAssertFalse(viewModel.movieDetailState.showFullOverview)

        viewModel.toggleOverviewExpanded()
        XCTAssertTrue(viewModel.movieDetailState.showFullOverview)

        viewModel.toggleOverviewExpanded()
        XCTAssertFalse(viewModel.movieDetailState.showFullOverview)
    }
}

private func makeMovieDetailInfoEntity(id: Int32) -> MovieDetailInfoEntity {
    return MovieDetailInfoEntity(
        id: id,
        title: "",
        originalTitle: nil,
        overview: "",
        releaseDate: nil,
        voteAverage: 0,
        voteCount: 0,
        genres: [],
        runtime: nil,
        backdropURL: nil,
        posterURL: nil
    )
}

private func makeCreditInfoEntitys() -> [CreditInfoEntity] {
    return [
        CreditInfoEntity(
            id: 1,
            name: "Actor 1",
            role: "Cast",
            profileURL: nil
        ),
        CreditInfoEntity(
            id: 2,
            name: "Actor 2",
            role: "Cast",
            profileURL: nil
        )
    ]
}

private func makeVideoItemEntitys() -> [VideoItemEntity] {
    return [
        VideoItemEntity(
            id: "1",
            name: "Trailer 1",
            site: "YouTube",
            key: "abcd",
            type: "Trailer"
        ),
        VideoItemEntity(
            id: "2",
            name: "Teaser",
            site: "YouTube",
            key: "efgh",
            type: "Teaser"
        )
    ]
}

private func makeSimilarItemEntitys() -> [SimilarItemEntity] {
    return [
        SimilarItemEntity(
            id: 100,
            title: "Similar 1",
            posterURL: nil
        ),
        SimilarItemEntity(
            id: 101,
            title: "Similar 2",
            posterURL: nil
        )
    ]
}
