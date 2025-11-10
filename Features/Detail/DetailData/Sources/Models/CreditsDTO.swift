//
//  MovieCreditsDTO.swift
//  DetailData
//
//  Created by 백래훈 on 11/7/25.
//

import Foundation
import DetailDomain

struct CreditsDTO: Decodable {
    let id: Int
    let cast: [CastDTO]
    let crew: [CrewDTO]
}

extension CreditsDTO {
    var toEntity: CreditsEntity {
        CreditsEntity(
            id: id,
            cast: cast.map { $0.toEntity },
            crew: crew.map { $0.toEntity }
        )
    }
}

struct CastDTO: Decodable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let knownForDepartment: String?
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?

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

struct CrewDTO: Decodable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let knownForDepartment: String?
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let creditID: String
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, popularity, department, job
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case creditID = "credit_id"
    }
}

extension CrewDTO {
    var toEntity: CrewEntity {
        CrewEntity(
            adult: adult,
            gender: gender,
            id: id,
            knownForDepartment: knownForDepartment,
            name: name,
            originalName: originalName,
            popularity: popularity,
            profilePath: profilePath,
            creditID: creditID,
            department: department,
            job: job
        )
    }
}
