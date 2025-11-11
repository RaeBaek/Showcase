//
//  SimilarMovieDTO.swift
//  DetailData
//
//  Created by 백래훈 on 11/5/25.
//

import Foundation
import DetailDomain

struct SimilarDTO: Decodable {
    let page: Int
    let results: [SimilarResultDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension SimilarDTO {
    var toEntity: SimilarEntity {
        SimilarEntity(
            page: page,
            results: results.map { $0.toEntity },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}

struct SimilarResultDTO: Decodable {
    let adult: Bool
    let backdropPath: String?
    let genreIDs: [Int]
    let id: Int
    let originalCountry: String?
    let originalLanguage: String
    let originalTitle: String?
    let originalName: String?
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
    let firstAirDate: String?
    let name: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalCountry = "original_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case name
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension SimilarResultDTO {
    var toEntity: SimilarResultEntity {
        SimilarResultEntity(
            adult: adult,
            backdropPath: backdropPath,
            genreIDs: genreIDs,
            id: id,
            originalCountry: originalCountry,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            originalName: originalName,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            firstAirDate: firstAirDate,
            name: name,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}
