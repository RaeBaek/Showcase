//
//  PopularListResponse.swift
//  Showcase
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

struct PopularListResponse<T: Decodable>: Decodable {
    let page: Int?
    let results: [T]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
