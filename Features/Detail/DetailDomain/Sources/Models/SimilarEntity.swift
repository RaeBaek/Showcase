//
//  SimilarMovieEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/5/25.
//

import Foundation

public struct SimilarEntity {
    let page: Int
    let results: [SimilarResultEntity]
    let totalPages: Int
    let totalResults: Int

    public init(
        page: Int,
        results: [SimilarResultEntity],
        totalPages: Int,
        totalResults: Int
    ) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

public struct SimilarResultEntity {
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

    public init(
        adult: Bool,
        backdropPath: String?,
        genreIDs: [Int],
        id: Int,
        originalCountry: String?,
        originalLanguage: String,
        originalTitle: String?,
        originalName: String?,
        overview: String,
        popularity: Double,
        posterPath: String?,
        releaseDate: String?,
        firstAirDate: String?,
        name: String?,
        title: String?,
        video: Bool?,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDs = genreIDs
        self.id = id
        self.originalCountry = originalCountry
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.firstAirDate = firstAirDate
        self.name = name
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

extension SimilarResultEntity {
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780/\(posterPath)")
    }
}

extension SimilarResultEntity {
    var toSimilarMovieItemEntity: SimilarItemEntity {
        SimilarItemEntity(
            id: id,
            title: title ?? name,
            posterURL: posterURL
        )
    }
}
