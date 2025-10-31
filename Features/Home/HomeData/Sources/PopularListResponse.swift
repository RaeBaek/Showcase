//
//  PopularListResponse.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

public struct PopularListResponse<T: Decodable>: Decodable {
    let page: Int?
    let results: [T]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    public init(page: Int?, results: [T]?, totalPages: Int?, totalResults: Int?) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
