//
//  ModifyDTO.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation
import HomeDomain

struct ModifyDTO: Decodable {
    let id: Int?
    let adult: Bool?
}

extension ModifyDTO {
    var toEntity: ModifyEntity {
        ModifyEntity(id: id, adult: adult)
    }
}
