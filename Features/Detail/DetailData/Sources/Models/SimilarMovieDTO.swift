//
//  SimilarMovieDTO.swift
//  DetailData
//
//  Created by 백래훈 on 11/5/25.
//

import Foundation
import DetailDomain

struct SimilarMovieDTO: Decodable {
    let page: Int
    let results: [SimilarMovieResultDTO]
}

extension SimilarMovieDTO {
    var toEntity: SimilarMovieEntity {
        SimilarMovieEntity(
            page: page,
            results: results.map { $0.toEntity }
        )
    }
}

struct SimilarMovieResultDTO: Decodable {
    let adult: Bool
    let backdropPath: String?
    let genreIDs: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension SimilarMovieResultDTO {
    var toEntity: SimilarMovieResultEntity {
        SimilarMovieResultEntity(
            adult: adult,
            backdropPath: backdropPath,
            genreIDs: genreIDs,
            id: id,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}
