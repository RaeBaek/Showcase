//
//  PopularPage.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/27/25.
//

import Foundation

public struct PopularPage<T> {
    public let items: [T]
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int

    public init(items: [T], page: Int, totalPages: Int, totalResults: Int) {
        self.items = items
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

public extension PopularPage {
    static var empty: Self { .init(items: [], page: 0, totalPages: 1, totalResults: 0) }
    var hasNext: Bool { page < totalPages }
}
