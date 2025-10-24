//
//  PopularTVEntity.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

public struct PopularTVEntity: Identifiable {
    public let adult: Bool?
    public let backdropPath: String?
    public let genreIDs: [Int]?
    public let id: Int?
    public let originCountry: [String]?
    public let originalLanguage: String?
    public let originalName: String?
    public let overview: String?
    public let popularity: Double?
    public let posterPath: String?
    public let firstAirDate: String?
    public let name: String?
    public let voteAverage: Double?
    public let voteCount: Int?

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
