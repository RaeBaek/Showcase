//
//  TVDetailDTO.swift
//  DetailData
//
//  Created by 백래훈 on 10/31/25.
//

import Foundation
import DetailDomain

// MARK: - TVDetailDTO
struct TVDetailDTO: Decodable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let createdBy: [CreatorDTO]
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [GenreDTO]
    let homepage: String?
    let id: Int32
    let inProduction: Bool
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: EpisodeDTO?
    let name: String
    let nextEpisodeToAir: EpisodeDTO?
    let networks: [NetworkDTO]
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let originCountry: [String]?
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompanyDTO]
    let productionCountries: [ProductionCountryDTO]
    let seasons: [SeasonDTO]
    let spokenLanguages: [SpokenLanguageDTO]
    let status: String
    let tagline: String?
    let type: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres
        case homepage
        case id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension TVDetailDTO {
    var toEntity: TVDetailEntity {
        TVDetailEntity(
            adult: adult,
            backdropPath: backdropPath,
            createdBy: createdBy.map { $0.toEntity },
            episodeRunTime: episodeRunTime,
            firstAirDate: firstAirDate,
            genres: genres.map { $0.toEntity },
            homepage: homepage,
            id: id,
            inProduction: inProduction,
            languages: languages,
            lastAirDate: lastAirDate,
            lastEpisodeToAir: lastEpisodeToAir?.toEntity,
            name: name,
            nextEpisodeToAir: nextEpisodeToAir?.toEntity,
            networks: networks.map { $0.toEntity },
            numberOfEpisodes: numberOfEpisodes,
            numberOfSeasons: numberOfSeasons,
            originCountry: originCountry,
            originalLanguage: originalLanguage,
            originalName: originalName,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            productionCompanies: productionCompanies.map { $0.toEntity },
            productionCountries: productionCountries.map { $0.toEntity },
            seasons: seasons.map { $0.toEntity },
            spokenLanguages: spokenLanguages.map { $0.toEntity },
            status: status,
            tagline: tagline,
            type: type,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}

// MARK: - Creator
struct CreatorDTO: Decodable, Hashable {
    let id: Int
    let creditID: String?
    let name: String
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name
        case gender
        case profilePath = "profile_path"
    }
}

extension CreatorDTO {
    var toEntity: CreatorEntity {
        CreatorEntity(
            id: id,
            creditID: creditID,
            name: name,
            gender: gender,
            profilePath: profilePath
        )
    }
}

// MARK: - Episode
struct EpisodeDTO: Decodable, Hashable {
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

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
    }
}

extension EpisodeDTO {
    var toEntity: EpisodeEntity {
        EpisodeEntity(
            id: id,
            name: name,
            overview: overview,
            voteAverage: voteAverage,
            voteCount: voteCount,
            airDate: airDate,
            episodeNumber: episodeNumber,
            productionCode: productionCode,
            runtime: runtime,
            seasonNumber: seasonNumber,
            showID: showID,
            stillPath: stillPath
        )
    }
}

// MARK: - Network
struct NetworkDTO: Decodable, Hashable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

extension NetworkDTO {
    var toEntity: NetworkEntity {
        NetworkEntity(
            id: id,
            logoPath: logoPath,
            name: name,
            originCountry: originCountry
        )
    }
}

// MARK: - Season
struct SeasonDTO: Decodable, Hashable {
    let airDate: String?
    let episodeCount: Int
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let seasonNumber: Int
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id
        case name
        case overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}

extension SeasonDTO {
    var toEntity: SeasonEntity {
        SeasonEntity(
            airDate: airDate,
            episodeCount: episodeCount,
            id: id,
            name: name,
            overview: overview,
            posterPath: posterPath,
            seasonNumber: seasonNumber,
            voteAverage: voteAverage
        )
    }
}
