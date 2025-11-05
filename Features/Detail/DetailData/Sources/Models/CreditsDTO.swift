//
//  CreditsDTO.swift
//  DetailData
//
//  Created by 백래훈 on 11/4/25.
//

import Foundation
import DetailDomain

public struct CreditsDTO: Codable {
    public let id: Int
    public let cast: [CastDTO]
}

extension CreditsDTO {
    var toEntity: CreditsEntity {
        CreditsEntity(id: id, cast: cast.map { $0.toEntity })
    }
}

public struct CastDTO: Codable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int
    let character: String
    let creditID: String
    let order: Int

    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, popularity, character, order
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castID = "cast_id"
        case creditID = "credit_id"
    }
}

extension CastDTO {
    var toEntity: CastEntity {
        CastEntity(
            adult: adult,
            gender: gender,
            id: id,
            knownForDepartment: knownForDepartment,
            name: name,
            originalName: originalName,
            popularity: popularity,
            profilePath: profilePath,
            castID: castID,
            character: character,
            creditID: creditID,
            order: order
        )
    }
}
