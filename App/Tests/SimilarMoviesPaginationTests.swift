//
//  SimilarMoviesPaginationTests.swift
//  Showcase
//
//  Created by 백래훈 on 11/26/26.
//

import XCTest

import DetailDomain

@testable import App

/// 실제 네트워크 호출 없이 RN 시트별 다음 페이지 조회와 작품 선택 검증을 확인합니다.
@MainActor
final class SimilarMoviesPaginationTests: XCTestCase {
    /// 마지막 페이지의 중복 작품은 제외하고, 새 작품만 상세 이동에 사용할 수 있는지 확인합니다.
    /// 마지막 페이지 이후에는 API를 다시 호출하지 않아야 합니다.
    func test_lastPage_isReturnedOnce_andAdditionalMovieCanBeSelected() async {
        let useCase = StubMovieDetailUseCase(
            responses: [.success(makePage(2, totalPages: 2, ids: [42, 43, 43]))]
        )
        let pagination = makePagination(
            useCase: useCase,
            initialPage: makePage(1, totalPages: 2, ids: [42])
        )
        defer { pagination.cancel() }

        let lastPage = await requestNextPage(for: pagination)
        let afterLastPage = await requestNextPage(for: pagination)
        let requestedPages = await useCase.requestedPages

        XCTAssertEqual(lastPage.status, "loaded")
        XCTAssertEqual(lastPage.page, 2)
        XCTAssertEqual(lastPage.hasMore, false)
        XCTAssertEqual(lastPage.movieIDs, [43])
        XCTAssertEqual(afterLastPage.status, "end")
        XCTAssertEqual(requestedPages, [2])

        let selection = Notification(
            name: .init("ShowcaseSimilarMovieSelected"),
            object: pagination.id.uuidString,
            userInfo: ["movieID": "43"]
        )
        XCTAssertEqual(SimilarMovieSelection.movieID(
            from: selection,
            requestID: pagination.id,
            allowedMovieIDs: pagination.allowedMovieIDs
        ), 43)
    }

    /// 응답의 전체 페이지 수가 더 크더라도 TMDB의 요청 상한인 500페이지에서 멈추는지 확인합니다.
    func test_apiPageLimit_stopsRequestsEvenWhenMorePagesAreReported() async {
        let useCase = StubMovieDetailUseCase()
        let pagination = makePagination(useCase: useCase, initialPage: makePage(500, totalPages: 1_001))
        defer { pagination.cancel() }

        let result = await requestNextPage(for: pagination)
        let requestedPages = await useCase.requestedPages

        XCTAssertEqual(result.status, "end")
        XCTAssertEqual(result.hasMore, false)
        XCTAssertTrue(requestedPages.isEmpty)
    }

    /// 추가 조회 실패 시 기존 작품 ID를 유지하고, 재시도하면 실패했던 페이지를 다시 요청하는지 확인합니다.
    func test_retryAfterFailure_requestsTheSamePage() async {
        let useCase = StubMovieDetailUseCase(responses: [
            .failure(.requestFailed),
            .success(makePage(2, totalPages: 3, ids: [43]))
        ])
        let pagination = makePagination(useCase: useCase, initialPage: makePage(1, totalPages: 3, ids: [42]))
        defer { pagination.cancel() }

        let failure = await requestNextPage(for: pagination)
        XCTAssertEqual(failure.status, "failed")
        XCTAssertEqual(failure.hasMore, true)
        XCTAssertEqual(pagination.allowedMovieIDs, [42])

        let retry = await requestNextPage(for: pagination)
        let requestedPages = await useCase.requestedPages

        XCTAssertEqual(retry.status, "loaded")
        XCTAssertEqual(retry.page, 2)
        XCTAssertEqual(requestedPages, [2, 2])
    }

    /// 첫 응답을 보류한 상태에서 다음 페이지를 다시 요청해도 API 호출이 한 번만 발생하는지 확인합니다.
    func test_requestWhileLoading_doesNotStartDuplicateFetch() async {
        let fetchStarted = expectation(description: "첫 추가 조회가 시작됨")
        let useCase = StubMovieDetailUseCase(fetchStarted: fetchStarted)
        let pagination = makePagination(useCase: useCase, initialPage: makePage(1, totalPages: 2))
        defer { pagination.cancel() }

        let firstRequest = Task { await requestNextPage(for: pagination) }
        await fulfillment(of: [fetchStarted], timeout: 2)

        let duplicate = await requestNextPage(for: pagination)
        await useCase.completeFetch(with: makePage(2, totalPages: 2))
        let firstResult = await firstRequest.value
        let requestedPages = await useCase.requestedPages

        XCTAssertEqual(duplicate.status, "busy")
        XCTAssertEqual(firstResult.status, "loaded")
        XCTAssertEqual(requestedPages, [2])
    }

    /// 이전 시트를 닫고 새 시트를 연 뒤에도 이전 요청 ID와 늦은 응답이 무시되는지 확인합니다.
    func test_dismissedSheet_discardsLateResponseAfterAnotherSheetOpens() async {
        let fetchStarted = expectation(description: "이전 시트의 추가 조회가 시작됨")
        let useCase = StubMovieDetailUseCase(fetchStarted: fetchStarted)
        let oldSheet = makePagination(useCase: useCase, initialPage: makePage(1, totalPages: 2, ids: [42]))

        let pendingRequest = Task { await requestNextPage(for: oldSheet) }
        await fulfillment(of: [fetchStarted], timeout: 2)
        oldSheet.cancel()

        let newSheet = makePagination(useCase: StubMovieDetailUseCase(), initialPage: makePage(1, totalPages: 2, ids: [51]))
        defer { newSheet.cancel() }

        let staleRequest = await requestNextPage(for: oldSheet)
        await useCase.completeFetch(with: makePage(2, totalPages: 2, ids: [43]))
        let lateResponse = await pendingRequest.value

        XCTAssertEqual(staleRequest.status, "inactive")
        XCTAssertEqual(lateResponse.status, "inactive")
        XCTAssertFalse(lateResponse.includesMovies)
        XCTAssertEqual(oldSheet.allowedMovieIDs, [42])
        XCTAssertEqual(newSheet.allowedMovieIDs, [51])
    }

    /// RN 브리지 응답에서 검증할 값만 추출해 비동기 작업의 결과로 전달합니다.
    private func requestNextPage(for pagination: SimilarMoviesPagination) async -> PageResponse {
        await withCheckedContinuation { continuation in
            SimilarMoviesPagination.requestNextPage(pagination.id.uuidString) {
                continuation.resume(returning: PageResponse($0))
            }
        }
    }

    private struct PageResponse: Sendable {
        let status: String?
        let page: Int?
        let hasMore: Bool?
        let movieIDs: [Int]?
        let includesMovies: Bool

        init(_ payload: NSDictionary) {
            status = payload["status"] as? String
            page = payload["page"] as? Int
            hasMore = payload["hasMore"] as? Bool
            let movies = payload["movies"]
            movieIDs = (movies as? [[String: Any]])?.compactMap { $0["id"] as? Int }
            includesMovies = movies != nil
        }
    }

    private func makePagination(
        useCase: StubMovieDetailUseCase,
        initialPage: SimilarMoviesPage
    ) -> SimilarMoviesPagination {
        SimilarMoviesPagination(movieID: 1, language: "ko-KR", initialPage: initialPage, useCase: useCase)
    }

    private func makePage(_ page: Int, totalPages: Int, ids: [Int] = []) -> SimilarMoviesPage {
        SimilarMoviesPage(
            items: ids.map { SimilarItemEntity(id: $0, title: nil, posterURL: nil) },
            page: page,
            totalPages: totalPages
        )
    }
}

/// 준비한 페이지 응답을 순서대로 반환하고, 요청된 페이지 번호를 기록합니다.
/// 응답 시점을 제어해야 하는 테스트에서는 첫 조회를 보류합니다.
private actor StubMovieDetailUseCase: MovieDetailUseCase {
    enum StubError: Error {
        case requestFailed
        case unexpectedRequest
    }

    private var responses: [Result<SimilarMoviesPage, StubError>]
    private var fetchStarted: XCTestExpectation?
    private var pendingFetch: CheckedContinuation<SimilarMoviesPage, any Error>?
    private(set) var requestedPages: [Int32] = []

    init(responses: [Result<SimilarMoviesPage, StubError>] = [], fetchStarted: XCTestExpectation? = nil) {
        self.responses = responses
        self.fetchStarted = fetchStarted
    }

    func fetchSimilar(_ input: DetailInput) async throws -> SimilarMoviesPage {
        requestedPages.append(input.page)
        if let fetchStarted {
            self.fetchStarted = nil
            return try await withCheckedThrowingContinuation { continuation in
                pendingFetch = continuation
                fetchStarted.fulfill()
            }
        }
        guard !responses.isEmpty else { throw StubError.unexpectedRequest }
        return try responses.removeFirst().get()
    }

    /// 보류 중인 첫 조회에 응답해 테스트가 지정한 시점에 조회를 재개합니다.
    func completeFetch(with page: SimilarMoviesPage) {
        pendingFetch?.resume(returning: page)
        pendingFetch = nil
    }

    func fetchDetail(_ input: DetailInput) async throws -> MovieDetailInfoEntity {
        throw StubError.unexpectedRequest
    }

    func fetchCredits(_ input: DetailInput) async throws -> [CreditInfoEntity] {
        throw StubError.unexpectedRequest
    }

    func fetchVideos(_ input: DetailInput) async throws -> [VideoItemEntity] {
        throw StubError.unexpectedRequest
    }
}
