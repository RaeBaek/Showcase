//
//  PopularTVDTO.swift
//  HomeData
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation
import HomeDomain

public struct PopularTVDTO: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDs: [Int]?
    let id: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let firstAirDate: String?
    let name: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult, id, overview, popularity, name
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    public init(
        adult: Bool?,
        backdropPath: String?,
        genreIDs: [Int]?,
        id: Int?,
        originCountry: [String]?,
        originalLanguage: String?,
        originalName: String?,
        overview: String?,
        popularity: Double?,
        posterPath: String?,
        firstAirDate: String?,
        name: String?,
        voteAverage: Double?,
        voteCount: Int?
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDs = genreIDs
        self.id = id
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.firstAirDate = firstAirDate
        self.name = name
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

extension PopularTVDTO {
    var toEntity: PopularTVEntity {
        PopularTVEntity(
            adult: adult,
            backdropPath: backdropPath,
            genreIDs: genreIDs,
            id: id ?? 0,
            originCountry: originCountry,
            originalLanguage: originalLanguage,
            originalName: originalName,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            firstAirDate: firstAirDate,
            name: name,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}
