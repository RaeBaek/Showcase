//
//  PeoplePagingUseCaseTests.swift
//  HomeDomainTests
//
//  Created by 백래훈 on 10/29/25.
//

import XCTest
import Combine
@testable import HomeDomain

@MainActor
final class PeoplePagingUseCaseTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    /// usecase의 loadFirstMovies 메서드 정상 동작 테스트
    func test_loadFirstPeople_publishesAndUpdateState() async throws {
        // given
        let repo = MockRepository()
        repo.peoplePages[1] = PopularPage<PopularPeopleEntity>(
            items: (1...10).map { .init(id: $0, name: "\($0)") },
            page: 1,
            totalPages: 2,
            totalResults: 20
        )
        let usecase = PeoplePagingUseCase(repository: repo)

        let exp = expectation(description: "first page published")
        var latestCount = -1
        usecase.itemsPublisher
            .drop(while: { $0.isEmpty })
            .sink { values in
                latestCount = values.count
                if values.count == 10 { exp.fulfill() }
            }
            .store(in: &cancellables)

        // when
        try await usecase.loadFirstPeople()

        // then
        await fulfillment(of: [exp], timeout: 1.0)
        XCTAssertEqual(latestCount, 10)
        XCTAssertEqual(repo.calls, [.people(1, "ko-KR")])
        XCTAssertEqual(usecase.items.count, 10)
        XCTAssertEqual(usecase.page, 1)
        XCTAssertEqual(usecase.totalPages, 2)
    }

    /// 추가 페이지 요청 메서드 정상 동작 테스트 (feat. 병렬 요청, 1회 호출)
    func test_loadMoreMovies_nearTail_loadSecondPageOnlyOnce() async throws {
        // given
        let repo = MockRepository()
        repo.peoplePages[1] = PopularPage<PopularPeopleEntity>(
            items: (1...10).map { .init(id: $0, name: "\($0)") },
            page: 1,
            totalPages: 2,
            totalResults: 20
        )
        repo.peoplePages[2] = PopularPage<PopularPeopleEntity>(
            items: (11...20).map { .init(id: $0, name: "\($0)") },
            page: 2,
            totalPages: 2,
            totalResults: 20
        )
        let usecase = PeoplePagingUseCase(repository: repo)

        try await usecase.loadFirstPeople()
        let trigger = usecase.items[usecase.items.count - 3]

        let exp = expectation(description: "second page appended")
        usecase.itemsPublisher
            .drop(while: { $0.isEmpty })
            .sink { values in
                if values.count == 20 { exp.fulfill() }
            }
            .store(in: &cancellables)

        // when: fire two concurrent calls, only one should pass the guards
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await usecase.loadMoreIfNeeded(currentItem: trigger, threshold: 3)
            }
            group.addTask {
                await usecase.loadMoreIfNeeded(currentItem: trigger, threshold: 3)
            }
        }
        
        // then
        await fulfillment(of: [exp], timeout: 1.0)
        XCTAssertEqual(repo.calls, [.people(1, "ko-KR"), .people(2, "ko-KR")])
        XCTAssertEqual(usecase.items.count, 20)
        XCTAssertEqual(usecase.page, 2)
        XCTAssertEqual(usecase.totalPages, 2)
        XCTAssertFalse(usecase.hasNext)
    }

    /// 첫 페이지 로드 실패 테스트
    func test_loadFirstMovies_progratesError() async throws {
        // given
        let repo = MockRepository()
        repo.peopleError = Stub.boom
        let usecase = PeoplePagingUseCase(repository: repo)

        // when / then
        do {
            try await usecase.loadFirstPeople()
            XCTFail("Expected throw, but succeeded")
            XCTAssertTrue(usecase.items.isEmpty)
        } catch {
            XCTAssertTrue(error is Stub)
        }

        XCTAssertEqual(usecase.items.count, 0)
        XCTAssertEqual(usecase.page, 0)
        XCTAssertEqual(usecase.totalPages, Int.max)
    }

    /// 다음 페이지가 없을 때 다음 페이지가 요청되지 않는지 테스트
    func test_hasNextFalse_preventsFurtherLoad() async throws {
        // given
        let repo = MockRepository()
        repo.peoplePages[1] = PopularPage<PopularPeopleEntity>(
            items: (1...10).map { .init(id: $0, name: "\($0)") },
            page: 1,
            totalPages: 1,
            totalResults: 10
        )
        let usecase = PeoplePagingUseCase(repository: repo)
        try await usecase.loadFirstPeople()

        // when
        let trigger = usecase.items[usecase.items.count - 3]
        await usecase.loadMorePeopleIfNeeded(currentItem: trigger)

        // then
        XCTAssertEqual(repo.calls.count, 1)
        XCTAssertEqual(repo.calls, [.people(1, "ko-KR")])
        XCTAssertEqual(usecase.items.count, 10)
        XCTAssertEqual(usecase.page, 1)
        XCTAssertEqual(usecase.totalPages, 1)
        XCTAssertFalse(usecase.hasNext)
    }
}
