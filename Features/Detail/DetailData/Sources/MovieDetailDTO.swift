//
//  MovieDetailDTO.swift
//  DetailData
//
//  Created by 백래훈 on 10/31/25.
//

import Foundation

// MARK: - Movie
struct MovieDetailDTO: Decodable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollectionDTO?
    let budget: Int?
    let genres: [GenreDTO]
    let homepage: String?
    let id: Int
    let imdbID: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompanyDTO]
    let productionCountries: [ProductionCountryDTO]
    let releaseDate: String?         // 필요 시 Date로 변환해서 써도 OK
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguageDTO]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Nested DTOs
struct GenreDTO: Decodable, Hashable {
    let id: Int
    let name: String
}

struct ProductionCompanyDTO: Decodable, Hashable {
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

struct ProductionCountryDTO: Decodable, Hashable {
    let iso3166_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguageDTO: Decodable, Hashable {
    let englishName: String?
    let iso639_1: String
    let name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

// TMDB에서 종종 포함되는 컬렉션 정보(여기 예시는 null)
struct BelongsToCollectionDTO: Decodable, Hashable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
