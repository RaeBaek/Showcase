//
//  ModifyListResponse.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

struct ModifyListResponse: Decodable {
    let results: [ModifyDTO]?
    let page: Int?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
