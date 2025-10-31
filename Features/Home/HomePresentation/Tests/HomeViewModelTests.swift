//
//  HomeViewModelTests.swift
//  HomePresentation
//
//  Created by 백래훈 on 10/23/25.
//

import XCTest
import Combine
@testable import HomeDomain
@testable import HomePresentation

@MainActor
final class HomeViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    /// 홈 피드 섹션 업데이트 (firstLoad) 테스트
    func test_firstLoad_success_updatesAllSections() async throws {
        // given
        let moviesUC = MockPagingUseCase<PopularMovieEntity>()
        let peopleUC = MockPagingUseCase<PopularPeopleEntity>()
        let tvsUC = MockPagingUseCase<PopularTVEntity>()

        // loadFirst 시 각 UC가 자신들의 첫 아이템을 방출하도록 설정
        // 첫 로드 시 퍼블리시 모방
        moviesUC.onLoadFirst = { [weak moviesUC] in
            moviesUC?.emit(
                [.init(id: 1, title: "M1"),
                 .init(id: 2, title: "M2")]
            )
        }
        peopleUC.onLoadFirst = { [weak peopleUC] in
            peopleUC?.emit([
                .init(id: 1, name: "P1"),
                .init(id: 2, name: "P2")
            ])
        }
        tvsUC.onLoadFirst = { [weak tvsUC] in
            tvsUC?.emit([.init(id: 1, name: "T1")])
        }

        let viewModel = HomeViewModel(
            moviesUsecase: moviesUC,
            peopleUsecase: peopleUC,
            tvsUsecase: tvsUC
        )

        let exp = expectation(description: "all sections updated")
        exp.expectedFulfillmentCount = 3

        viewModel.$movies
            .drop(while: { $0.isEmpty })
            .sink { values in
                if values.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.$people
            .drop(while: { $0.isEmpty })
            .sink { values in
                if values.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.$tvs
            .drop(while: { $0.isEmpty })
            .sink { values in
                if values.count == 1 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        // when
        await viewModel.firstLoad()

        // then
        await fulfillment(of: [exp], timeout: 1.0)
        XCTAssertEqual(viewModel.movies.map { $0.id }, [1, 2])
        XCTAssertEqual(viewModel.people.map { $0.name }, ["P1", "P2"])
        XCTAssertEqual(viewModel.tvs.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }

    /// Movie 섹션 오류 전달 및 에러 메시지 방출 테스트
    func test_firstLoad_error_setsErrorMessage_andStopFlow() async throws {
        // given: movies에서 에러를 던지도록 설정
        enum Stub: Error { case boom }

        let moviesUC = MockPagingUseCase<PopularMovieEntity>()
        let peopleUC = MockPagingUseCase<PopularPeopleEntity>()
        let tvsUC = MockPagingUseCase<PopularTVEntity>()

        moviesUC.onLoadFirst = {
            throw Stub.boom
        }

        peopleUC.onLoadFirst = { [weak peopleUC] in
            peopleUC?.emit([
                .init(id: 10, name: "P10"),
                .init(id: 20, name: "P20")
            ])
        }

        tvsUC.onLoadFirst = { [weak tvsUC] in
            tvsUC?.emit([
                .init(id: 1, name: "T1"),
                .init(id: 2, name: "T2")
            ])
        }

        let viewModel = HomeViewModel(
            moviesUsecase: moviesUC,
            peopleUsecase: peopleUC,
            tvsUsecase: tvsUC
        )

        // when
        await viewModel.firstLoad()

        // then: 에러 메시지가 설정되고, 최소한 movies는 비어있을 가능성이 높음
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.movies.count, 0)
    }

    /// Movie 섹션 다음 페이지가 있을 경우 섹션 업데이트 테스트
    func test_onMovieAppear_relaysToUseCase_whenNearTail() async {
        // given
        let moviesUC = MockPagingUseCase<PopularMovieEntity>()
        let peopleUC = MockPagingUseCase<PopularPeopleEntity>()
        let tvsUC = MockPagingUseCase<PopularTVEntity>()

        let viewModel = HomeViewModel(
            moviesUsecase: moviesUC,
            peopleUsecase: peopleUC,
            tvsUsecase: tvsUC
        )

        // ViewModel은 UC의 publisher를 구독하여 movies를 반영하므로, items 먼저 전달
        let items = (1...10).map { PopularMovieEntity(id: $0, title: "\($0)") }
        moviesUC.emit(items)

        // 다음 페이지 items 미리 생성
        let items2 = (11...20).map { PopularMovieEntity(id: $0, title: "\($0)") }

        moviesUC.onLoadMore = { [weak moviesUC] (item, threshold) in
            if moviesUC?.items[items.count - 5].id == item.id,
               moviesUC?.hasNext == true {
                let merged = items + items2
                moviesUC?.emit(merged)
            }
        }

        let exp = expectation(description: "movies sections updated")

        viewModel.$movies
            .sink { values in
                if values.count == 20 {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        // when: 리스트의 끝에서 -5번째 아이템이 보였다고 가정
        let trigger = moviesUC.items[items.count - 5]
        await viewModel.onMovieAppear(trigger)

        // then
        await fulfillment(of: [exp], timeout: 1.0)
        XCTAssertEqual(viewModel.movies.count, 20)
        XCTAssertNil(viewModel.errorMessage)
    }

    /// view에서 사용되는 viewModel에 선언된 변수들이 publish를 제대로 구독하는지 테스트
    func test_binding_update_whenUseCasesPublish() {
        // given
        let moviesUC = MockPagingUseCase<PopularMovieEntity>()
        let peopleUC = MockPagingUseCase<PopularPeopleEntity>()
        let tvsUC = MockPagingUseCase<PopularTVEntity>()

        let viewModel = HomeViewModel(
            moviesUsecase: moviesUC,
            peopleUsecase: peopleUC,
            tvsUsecase: tvsUC
        )

        let exp = expectation(description: "binding updated")
        exp.expectedFulfillmentCount = 3

        viewModel.$movies
            .drop(while: { $0.isEmpty })
            .sink { _ in exp.fulfill() }
            .store(in: &cancellables)

        viewModel.$people
            .drop(while: { $0.isEmpty })
            .sink { _ in exp.fulfill() }
            .store(in: &cancellables)

        viewModel.$tvs
            .drop(while: { $0.isEmpty })
            .sink { _ in exp.fulfill() }
            .store(in: &cancellables)

        // when
        moviesUC.emit([.init(id: 1, title: "M1")])
        peopleUC.emit([.init(id: 10, name: "P10")])
        tvsUC.emit([.init(id: 100, name: "T100")])

        // then
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.people.count, 1)
        XCTAssertEqual(viewModel.tvs.count, 1)
    }
}
