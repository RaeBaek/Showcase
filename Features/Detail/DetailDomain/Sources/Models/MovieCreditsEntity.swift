//
//  CreditsEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/4/25.
//

import Foundation

public struct MovieCreditsEntity {
    let id: Int
    let cast: [MovieCastEntity]
    let crew: [MovieCrewEntity]

    public init(
        id: Int,
        cast: [MovieCastEntity],
        crew: [MovieCrewEntity]
    ) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }
}

public struct MovieCastEntity {
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

    public init(
        adult: Bool,
        gender: Int?,
        id: Int,
        knownForDepartment: String?,
        name: String,
        originalName: String,
        popularity: Double,
        profilePath: String?,
        castID: Int?,
        character: String?,
        creditID: String,
        order: Int?
    ) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.castID = castID
        self.character = character
        self.creditID = creditID
        self.order = order
    }
}

public struct MovieCrewEntity {
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

    public init(
        adult: Bool,
        gender: Int?,
        id: Int,
        knownForDepartment: String?,
        name: String,
        originalName: String,
        popularity: Double,
        profilePath: String?,
        creditID: String,
        department: String?,
        job: String?
    ) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.creditID = creditID
        self.department = department
        self.job = job
    }
}

protocol ProfileURLConvertible {
    var profileURL: URL? { get }
}

extension MovieCastEntity: ProfileURLConvertible {
    var profileURL: URL? {
        guard let profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/h632\(profilePath)")
    }
}

extension MovieCastEntity {
    var toCredit: CreditPersonEntity {
        CreditPersonEntity(
            id: id,
            name: name,
            role: character,
            profileURL: profileURL
        )
    }
}

extension MovieCrewEntity: ProfileURLConvertible {
    var profileURL: URL? {
        guard let profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/h632\(profilePath)")
    }
}

extension MovieCrewEntity {
    var toCredit: CreditPersonEntity {
        CreditPersonEntity(
            id: id,
            name: name,
            role: job,
            profileURL: profileURL
        )
    }
}
