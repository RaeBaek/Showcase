//
//  Modify.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation

// Network Response
struct ModifyListResponse: Decodable {
    let results: [ModifyDTO]
    let page: Int
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// DTO
struct ModifyDTO: Decodable {
    let id: Int?
    let adult: Bool?
}

// Entity
struct ModifyEntity: Identifiable {
    let id: Int?
    let adult: Bool?
}

extension ModifyDTO {
    var toModify: ModifyEntity {
        ModifyEntity(id: id, adult: adult)
    }
}
