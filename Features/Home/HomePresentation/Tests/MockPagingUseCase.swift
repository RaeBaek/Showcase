//
//  MockPagingUseCase.swift
//  HomePresentationTests
//
//  Created by 백래훈 on 10/30/25.
//

import Foundation
import Combine
@testable import HomeDomain

@MainActor
final class MockPagingUseCase<Entity: Identifiable>: PagingUseCase where Entity.ID == Int {
    private let subject = CurrentValueSubject<[Entity], Never>([])

    // PagingUseCase property
    var items: [Entity] { subject.value }
    private(set) var _hasNext: Bool = true
    var hasNext: Bool { _hasNext }

    // Publisher
    var itemsPublisher: AnyPublisher<[Entity], Never> { subject.eraseToAnyPublisher() }

    // MARK: - 테스트를 위한 클로저
    /// 'loadFirst()'가 호출되면 호출 / 성공, 실패 시뮬레이션 동작
    var onLoadFirst: (() async throws -> Void)?
    /// 'loadMoreIfNeeded()'가 호출되면 호출 / 페이징 시뮬레이션 동작
    var onLoadMore: ((_ current: Entity, _ threshold: Int) async -> Void)?

    /// 더 많은 페이지 요청 시 저장
    private(set) var loadMoreCalls: [(item: Entity, threshold: Int)] = []
    /// 'loadFirst()'가 몇 회 호출됐는지 저장
    private(set) var loadFirstCallCount: Int = 0

    // MARK: - 테스트 헬퍼
    func emit(_ newItems: [Entity]) { subject.send(newItems) }

    func setHasNext(_ value: Bool) { _hasNext = value }

    // MARK: - PagingUseCase 메서드 구현체
    func loadFirst() async throws {
        loadFirstCallCount += 1
        if let op = onLoadFirst { try await op() }
    }

    func loadMoreIfNeeded(currentItem: Entity, threshold: Int) async {
        loadMoreCalls.append((currentItem, threshold))
        if let op = onLoadMore { await op(currentItem, threshold)}
    }
}
