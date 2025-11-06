//
//  PersonEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/6/25.
//

import Foundation

public struct PersonEntity {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    public let birthday: String?
    public let deathday: String?
    let gender: Int
    public let homepage: String?
    let id: Int
    let imdbID: String?
    public let knownForDepartment: String
    public let name: String
    public let placeOfBirth: String?
    public let popularity: Double
    public let profilePath: String?

    public init(
        adult: Bool,
        alsoKnownAs: [String],
        biography: String,
        birthday: String?,
        deathday: String?,
        gender: Int,
        homepage: String?,
        id: Int,
        imdbID: String?,
        knownForDepartment: String,
        name: String,
        placeOfBirth: String?,
        popularity: Double,
        profilePath: String?
    ) {
        self.adult = adult
        self.alsoKnownAs = alsoKnownAs
        self.biography = biography
        self.birthday = birthday
        self.deathday = deathday
        self.gender = gender
        self.homepage = homepage
        self.id = id
        self.imdbID = imdbID
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.placeOfBirth = placeOfBirth
        self.popularity = popularity
        self.profilePath = profilePath
    }
}

extension PersonEntity {
    var toPersonDetailEntity: PersonDetailEntity {
        PersonDetailEntity(
            id: id,
            name: name,
            profilePath: profilePath,
            knownForDepartment: knownForDepartment,
            birthday: birthday,
            deathday: deathday,
            placeOfBirth: placeOfBirth,
            homepage: homepage,
            popularity: popularity,
            biography: biography
        )
    }
}
