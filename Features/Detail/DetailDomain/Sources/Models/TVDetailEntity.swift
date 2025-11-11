//
//  TVDetailEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

public struct TVDetailEntity: Identifiable {
    let adult: Bool
    let backdropPath: String?
    let createdBy: [CreatorEntity]
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [GenreEntity]
    let homepage: String?
    public let id: Int32
    let inProduction: Bool
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: EpisodeEntity?
    let name: String
    let nextEpisodeToAir: EpisodeEntity?
    let networks: [NetworkEntity]
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let originCountry: [String]?
    let originalLanguage: String
    let originalName: String?
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompanyEntity]
    let productionCountries: [ProductionCountryEntity]
    let seasons: [SeasonEntity]
    let spokenLanguages: [SpokenLanguageEntity]
    let status: String
    let tagline: String?
    let type: String
    let voteAverage: Double
    let voteCount: Int

    public init(
        adult: Bool,
        backdropPath: String?,
        createdBy: [CreatorEntity],
        episodeRunTime: [Int]?,
        firstAirDate: String?,
        genres: [GenreEntity],
        homepage: String?,
        id: Int32,
        inProduction: Bool,
        languages: [String]?,
        lastAirDate: String?,
        lastEpisodeToAir: EpisodeEntity?,
        name: String,
        nextEpisodeToAir: EpisodeEntity?,
        networks: [NetworkEntity],
        numberOfEpisodes: Int,
        numberOfSeasons: Int,
        originCountry: [String]?,
        originalLanguage: String,
        originalName: String,
        overview: String,
        popularity: Double,
        posterPath: String?,
        productionCompanies: [ProductionCompanyEntity],
        productionCountries: [ProductionCountryEntity],
        seasons: [SeasonEntity],
        spokenLanguages: [SpokenLanguageEntity],
        status: String,
        tagline: String?,
        type: String,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.createdBy = createdBy
        self.episodeRunTime = episodeRunTime
        self.firstAirDate = firstAirDate
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.inProduction = inProduction
        self.languages = languages
        self.lastAirDate = lastAirDate
        self.lastEpisodeToAir = lastEpisodeToAir
        self.name = name
        self.nextEpisodeToAir = nextEpisodeToAir
        self.networks = networks
        self.numberOfEpisodes = numberOfEpisodes
        self.numberOfSeasons = numberOfSeasons
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.seasons = seasons
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.type = type
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

extension TVDetailEntity {
    var toInfo: TVDetailInfoEntity {
        TVDetailInfoEntity(
            id: id,
            name: name,
            originalName: originalName,
            tagline: tagline,
            posterPath: posterPath,
            backdropPath: backdropPath,
            firstAirDate: firstAirDate,
            lastAirDate: lastAirDate,
            status: status,
            inProduction: inProduction,
            numberOfSeasons: numberOfSeasons,
            numberOfEpisodes: numberOfEpisodes,
            episodeRunTime: episodeRunTime,
            createdBy: createdBy,
            networks: networks,
            homepage: homepage,
            overview: overview,
            genres: genres,
            originCountry: originCountry,
            originalLanguage: originalLanguage,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}

public struct CreatorEntity {
    let id: Int
    let creditID: String?
    let name: String
    let gender: Int?
    let profilePath: String?

    public init(
        id: Int,
        creditID: String?,
        name: String,
        gender: Int?,
        profilePath: String?
    ) {
        self.id = id
        self.creditID = creditID
        self.name = name
        self.gender = gender
        self.profilePath = profilePath
    }
}

public struct EpisodeEntity {
    let id: Int
    let name: String
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let airDate: String?
    let episodeNumber: Int?
    let productionCode: String?
    let runtime: Int?
    let seasonNumber: Int?
    let showID: Int?
    let stillPath: String?

    public init(
        id: Int,
        name: String,
        overview: String,
        voteAverage: Double,
        voteCount: Int,
        airDate: String?,
        episodeNumber: Int?,
        productionCode: String?,
        runtime: Int?,
        seasonNumber: Int?,
        showID: Int?,
        stillPath: String?
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.productionCode = productionCode
        self.runtime = runtime
        self.seasonNumber = seasonNumber
        self.showID = showID
        self.stillPath = stillPath
    }
}

public struct NetworkEntity {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String?

    public init(
        id: Int,
        logoPath: String?,
        name: String,
        originCountry: String?
    ) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
}

public struct SeasonEntity {
    let airDate: String?
    let episodeCount: Int
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let seasonNumber: Int
    let voteAverage: Double

    public init(
        airDate: String?,
        episodeCount: Int,
        id: Int,
        name: String,
        overview: String,
        posterPath: String?,
        seasonNumber: Int,
        voteAverage: Double
    ) {
        self.airDate = airDate
        self.episodeCount = episodeCount
        self.id = id
        self.name = name
        self.overview = overview
        self.posterPath = posterPath
        self.seasonNumber = seasonNumber
        self.voteAverage = voteAverage
    }
}

public struct TVSummaryEntity {

}
