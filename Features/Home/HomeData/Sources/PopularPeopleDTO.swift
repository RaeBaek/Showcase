//
//  PopularPeopleDTO.swift
//  HomeData
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation
import HomeDomain

public struct PopularPeopleDTO: Decodable {
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

    public init(
        adult: Bool?,
        gender: Int?,
        id: Int?,
        knownFor: [KnownForDTO]?,
        knownForDepartment: String?,
        name: String?,
        popularity: Double?,
        profilePath: String?
    ) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownFor = knownFor
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.popularity = popularity
        self.profilePath = profilePath
    }
}

extension PopularPeopleDTO {
    var toEntity: PopularPeopleEntity {
        PopularPeopleEntity(
            adult: adult,
            gender: gender,
            id: id ?? 0,
            knownFor: knownFor?.map { $0.toEntity },
            knownForDepartment: knownForDepartment,
            name: name,
            popularity: popularity,
            profilePath: profilePath
        )
    }
}

public struct KnownForDTO: Decodable {
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

    public init(
        adult: Bool?,
        backdropPath: String?,
        genreIDs: [Int]?,
        id: Int?,
        mediaType: String?,
        originalLanguage: String?,
        originalTitle: String?,
        overview: String?,
        posterPath: String?,
        releaseDate: String?,
        title: String?,
        video: Bool?,
        voteAverage: Double?,
        voteCount: Int?
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDs = genreIDs
        self.id = id
        self.mediaType = mediaType
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
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
