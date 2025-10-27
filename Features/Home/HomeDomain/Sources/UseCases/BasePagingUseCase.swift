//
//  BasePagingUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/27/25.
//

import Foundation

@MainActor
public class BasePagingUseCase<T: Identifiable>: PagingUseCase where T.ID == Int {
    public typealias Fetch = (Int) async throws -> PopularPage<T>

    private let fetch: Fetch

    public init(fetch: @escaping Fetch) {
        self.fetch = fetch
    }

    public private(set) var items: [T] = []
    public private(set) var page = 0
    public private(set) var totalPages = Int.max
    public private(set) var isLoading = false
    private var lastRequested = 0

    public var hasNext: Bool { page < totalPages }

    public func loadFirst() async throws {
        items.removeAll()
        page = 0
        totalPages = .max
        lastRequested = 0
        try await load(next: 1)
    }

    public func loadMoreIfNeeded(currentItem: T, threshold: Int = 5) async {
        guard !isLoading, hasNext else { return }
        guard let idx = items.firstIndex(where: { $0.id == currentItem.id }),
              idx >= max(0, items.count - threshold) else { return }

        await loadSafely(next: page + 1)
    }

    // 내부 공용 로딩 로직
    private func loadSafely(next: Int) async {
        guard !isLoading, next != lastRequested, next <= totalPages else { return }
        isLoading = true
        lastRequested = next
        defer { isLoading = false }

        do {
            let newPage = try await fetch(next)
            items += newPage.items
            page = newPage.page
            totalPages = newPage.totalPages
        } catch {
            lastRequested = page
        }
    }

    private func load(next: Int) async throws {
        isLoading = true
        lastRequested = next
        defer { isLoading = false }

        let newPage = try await fetch(next)
        items = newPage.items
        page = newPage.page
        totalPages = newPage.totalPages
    }
}
