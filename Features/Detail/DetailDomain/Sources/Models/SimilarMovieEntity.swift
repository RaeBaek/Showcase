//
//  SimilarMovieEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/5/25.
//

import Foundation

public struct SimilarMovieEntity {
    let page: Int
    let results: [SimilarMovieResultEntity]

    public init(page: Int, results: [SimilarMovieResultEntity]) {
        self.page = page
        self.results = results
    }
}

public struct SimilarMovieResultEntity {
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

    public init(
        adult: Bool,
        backdropPath: String?,
        genreIDs: [Int],
        id: Int,
        originalLanguage: String,
        originalTitle: String,
        overview: String,
        popularity: Double,
        posterPath: String?,
        releaseDate: String?,
        title: String,
        video: Bool,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDs = genreIDs
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

extension SimilarMovieResultEntity {
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780/\(posterPath)")
    }
}

extension SimilarMovieResultEntity {
    var toSimilarMovieItemEntity: SimilarMovieItemEntity {
        SimilarMovieItemEntity(
            id: id,
            title: title,
            posterURL: posterURL
        )
    }
}
