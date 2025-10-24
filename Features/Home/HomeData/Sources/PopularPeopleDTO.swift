//
//  PopularPeopleDTO.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation
import HomeDomain

struct PopularPeopleDTO: Decodable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownFor: [KnownForDTO]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name, popularity
        case profilePath = "profile_path"
    }
}

extension PopularPeopleDTO {
    var toEntity: PopularPeopleEntity {
        PopularPeopleEntity(
            adult: adult,
            gender: gender,
            id: id,
            knownFor: knownFor?.map { $0.toEntity },
            knownForDepartment: knownForDepartment,
            name: name,
            popularity: popularity,
            profilePath: profilePath
        )
    }
}

struct KnownForDTO: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDs: [Int]?
    let id: Int?
    let mediaType: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult, id, overview, title, video
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension KnownForDTO {
    var toEntity: KnownForEntity {
        KnownForEntity(
            adult: adult,
            backdropPath: backdropPath,
            genreIDs: genreIDs,
            id: id,
            mediaType: mediaType,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}
