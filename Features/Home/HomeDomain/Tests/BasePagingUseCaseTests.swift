//
//  BasePagingUseCaseTests.swift
//  HomeDomainTests
//
//  Created by 백래훈 on 10/23/25.
//

import XCTest
import Combine
@testable import HomeDomain

final class BasePagingUseCaseTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    /// BasePagingUseCase<DummyEntity> 타입을 반환하는 메서드
    /// pages: 키는 페이지 번호(Int), 값은 각 페이지의 PopularPage<DummyEntity> 데이터
    /// fetchDelayNanos: 비동기 호출의 지연(딜레이)을 시뮬레이션
    /// callCounter: 단순한 호출 횟수 추적
    /// return BasePagingUseCase<DummyEntity>(fetch: { next in ...}): 클로저 구문을 통해 가짜 fetch(mock data)를 반환하게 됨
    @MainActor
    private func makeUseCase(
        pages: [Int: PopularPage<DummyEntity>],
        fetchDelayNanos: UInt64 = 0,
        callCounter: Counter
    ) -> BasePagingUseCase<DummyEntity> {
        return BasePagingUseCase<DummyEntity>(fetch: { next in
            callCounter.value += 1
            if fetchDelayNanos > 0 { try await Task.sleep(nanoseconds: fetchDelayNanos) }
            guard let page = pages[next] else { throw URLError(.badServerResponse) }
            return page
        })
    }

    /// 페이징 UseCase의 첫 로드(loadFirst)가 의도한 대로 동작하는지 검증 테스트
    @MainActor
    func test_loadFirst_setsFirstPageAndItem_andPublishes() async throws {
        // given
        /// 테스트용 DummyPage 데이터 정의
        let p1 = PopularPage<DummyEntity>(
            items: [.init(id: 1, name: "A"), .init(id: 2, name: "B")],
            page: 1,
            totalPages: 3,
            totalResults: 30
        )
        /// 호출 횟수를 추적하는 테스트용 카운터 객체
        let calls = Counter()
        /// 테스트용 usecase 생성
        let uc = makeUseCase(
            pages: [1: p1],
            fetchDelayNanos: 2,
            callCounter: calls
        )

        /// 비동기 이벤트 검증을 위한 expectation
        let exp = expectation(description: "items published")
        var published: [[DummyEntity]] = []
        uc.itemsPublisher
            .sink { values in
                published.append(values)
                if values == p1.items {
                    /// 비동기 대기 종료
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        // when
        /// 첫 페이지 로드
        try await uc.loadFirst()

        // then
        /// expectation이 1초 안에 충족되는지 대기
        await fulfillment(of: [exp], timeout: 1.0)
        XCTAssertEqual(uc.items, p1.items)
        XCTAssertEqual(uc.hasNext, true)
        XCTAssertEqual(calls.value, 1)
        XCTAssertEqual(uc.page, 1)
        XCTAssertEqual(uc.totalPages, 3)
        XCTAssertFalse(uc.items.isEmpty)
        XCTAssertTrue(!published.isEmpty)
    }

    /// 배열 끝단 근처에 도달했을 때 다음 페이지를 요청하는 테스트
    @MainActor
    func test_loadMoreIfNeeded_triggerNearTail_onlyOnce() async throws {
        // given
        let p1 = PopularPage<DummyEntity>(
            items: (1...10).map { .init(id: $0, name: "\($0)") },
            page: 1,
            totalPages: 2,
            totalResults: 20
        )
        let p2 = PopularPage<DummyEntity>(
            items: (11...20).map { .init(id: $0, name: "\($0)") },
            page: 2,
            totalPages: 2,
            totalResults: 20
        )
        let calls = Counter()

        /// 테스트용 usecase 생성
        let uc = makeUseCase(
            pages: [1: p1, 2: p2],
            fetchDelayNanos: 2,
            callCounter: calls
        )

        /// 비동기 이벤트 검증을 위한 expectation
        let exp = expectation(description: "second page appended")
        var published: [[DummyEntity]] = []
        uc.itemsPublisher
            .sink { values in
                published.append(values)
                if values.count == 20 {
                    /// 비동기 대기 종료
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        /// 첫 페이지 로드 & 호출 수 검증
        try await uc.loadFirst()
        XCTAssertEqual(calls.value, 1)

        // when: appear near the tail (threshold 3)
        /// 배열 꼬리 진입 트리거 아이템 선택 및 다음 페이지 로드
        let triggerItem = p1.items[p1.items.count - 3]
        await uc.loadMoreIfNeeded(currentItem: triggerItem, threshold: 3)

        // then
        /// expectation이 1초 안에 충족되는지 대기
        await fulfillment(of: [exp], timeout: 1.0)
        XCTAssertEqual(calls.value, 2)
        XCTAssertEqual(uc.items.count, 20)
        XCTAssertEqual(uc.page, 2)
        XCTAssertFalse(uc.hasNext)
        /// 초기값 []
        /// loadFirst() 호출 (내부적으로 items.removeAllI() 호출) -> p1 전달
        /// 다음 페이지 p2 전달
        /// 총 4개의 배열이 전달되어 count는 4
        XCTAssertEqual(published.count, 4)
    }

    /// 다음 페이지를 요청하고 이전 배열에 추가할 때 중복을 제거하는지 테스트
    @MainActor
    func test_noDuplicates_whenPagesOverlap() async throws {
        // given: page2 overlaps ids with page1
        let p1 = PopularPage<DummyEntity>(
            items: (1...6).map { .init(id: $0, name: "\($0)") },
            page: 1,
            totalPages: 2,
            totalResults: 20
        )
        let p2 = PopularPage<DummyEntity>(
            items: (6...10).map { .init(id: $0, name: "\($0)") },
            page: 2,
            totalPages: 2,
            totalResults: 20
        )
        let calls = Counter()

        let uc = makeUseCase(
            pages: [1: p1, 2: p2],
            fetchDelayNanos: 3,
            callCounter: calls
        )

        // when
        try await uc.loadFirst()
        let triggerItem = p1.items[p1.items.count - 3]
        await uc.loadMoreIfNeeded(currentItem: triggerItem, threshold: 3)

        // then: id 6은 한 번만 등장해야 함
        XCTAssertEqual(uc.items.map { $0.id }.filter { $0 == 6 }.count, 1)
        XCTAssertEqual(uc.items.count, (p1.items.count + p2.items.count) - 1)
    }

    /// 첫 페이지 로드 실패 테스트
    @MainActor
    func test_errorOnLoadFirst_isPropagated_andStateRolledBack() async throws {
        // given: page 1 throws
        let counter = Counter()
        let uc = BasePagingUseCase<DummyEntity>(fetch: { _ in
            counter.value += 1
            throw URLError(.timedOut)
        })

        // when / then
        do {
            try await uc.loadFirst()
            XCTFail("Expected throw, but succeeded")
        } catch {
            XCTAssertTrue(error is URLError)
        }

        XCTAssertEqual(counter.value, 1)
        XCTAssertTrue(uc.items.isEmpty)
        XCTAssertEqual(uc.page, 0)
        XCTAssertEqual(uc.totalPages, Int.max)
    }

    /// isLoading 가드, 동시 요청 중 오직 한 건만 처리 가능한지 테스트
    @MainActor
    func test_isLoadingGuards_concurrentLoadMore_requestOnlyOnce() async throws {
        // given: slow fetch to simulate overlap
        let p1 = PopularPage<DummyEntity>(
            items: (1...10).map { .init(id: $0, name: "\($0)") },
            page: 1,
            totalPages: 3,
            totalResults: 30
        )
        let p2 = PopularPage<DummyEntity>(
            items: (11...20).map { .init(id: $0, name: "\($0)") },
            page: 2,
            totalPages: 3,
            totalResults: 30
        )
        let counter = Counter()
        let uc = makeUseCase(
            pages: [1: p1, 2: p2],
            fetchDelayNanos: 3,
            callCounter: counter
        )

        try await uc.loadFirst()
        let trigger = p1.items[p1.items.count - 3]

        // when: fire two loadMore calls concurrently
        /// 두 Task를 동시에 요청하기 위한 withTaskGroup
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await uc.loadMoreIfNeeded(currentItem: trigger, threshold: 3)
            }
            group.addTask {
                await uc.loadMoreIfNeeded(currentItem: trigger, threshold: 3)
            }
        }

        // then: fetch should be called only once due to isLoading guard
        XCTAssertEqual(counter.value, 2)
        XCTAssertEqual(uc.page, 2)
        XCTAssertEqual(uc.items.count, 20)
    }

    /// 다음 페이지가 없을 때 다음 페이지가 요청되지 않는지 테스트
    @MainActor
    func test_hasNextFalse_preventsFurtherLoad() async throws {
        let p1 = PopularPage<DummyEntity>(
            items: (1...10).map { .init(id: $0, name: "\($0)") },
            page: 1,
            totalPages: 1,
            totalResults: 10
        )
        let counter = Counter()
        let uc = makeUseCase(pages: [1: p1], callCounter: counter)

        try await uc.loadFirst()
        XCTAssertFalse(uc.hasNext)

        let trigger = uc.items[uc.items.count - 3]
        await uc.loadMoreIfNeeded(currentItem: trigger, threshold: 3)

        XCTAssertEqual(counter.value, 1)
        XCTAssertEqual(uc.page, 1)
        XCTAssertEqual(uc.items.count, 10)
    }
}

struct DummyEntity: Identifiable, Equatable {
    let id: Int
    let name: String
}

private final class Counter {
    var value: Int = 0
}
