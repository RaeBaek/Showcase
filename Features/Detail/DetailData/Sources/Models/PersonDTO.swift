//
//  PersonDTO.swift
//  DetailData
//
//  Created by 백래훈 on 11/6/25.
//

import Foundation
import DetailDomain

struct PersonDTO: Codable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String?
    let deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int32
    let imdbID: String?
    let knownForDepartment: String
    let name: String
    let placeOfBirth: String?
    let popularity: Double
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography
        case birthday
        case deathday
        case gender
        case homepage
        case id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}

extension PersonDTO {
    var toEntity: PersonEntity {
        PersonEntity(
            adult: adult,
            alsoKnownAs: alsoKnownAs,
            biography: biography,
            birthday: birthday,
            deathday: deathday,
            gender: gender,
            homepage: homepage,
            id: id,
            imdbID: imdbID,
            knownForDepartment: knownForDepartment,
            name: name,
            placeOfBirth: placeOfBirth,
            popularity: popularity,
            profilePath: profilePath
        )
    }
}
