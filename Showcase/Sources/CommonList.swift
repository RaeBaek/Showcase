//
//  CommonList.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation

// Network Response
struct ModifyListResponse: Decodable {
    let results: [ModifyListDTO]
}

// DTO
struct ModifyListDTO: Decodable {
    let id: Int?
    let adult: Bool?
}

// Entity
struct ModifyEntity: Identifiable {
    let id: Int?
    let adult: Bool?
}

extension ModifyListDTO {
    var toModify: ModifyEntity {
        ModifyEntity(id: id, adult: adult)
    }
}
