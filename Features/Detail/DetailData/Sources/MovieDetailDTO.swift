//
//  MovieDetailDTO.swift
//  DetailData
//
//  Created by 백래훈 on 10/31/25.
//

import Foundation
import DetailDomain

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

extension MovieDetailDTO {
    var toEntity: MovieDetailEntity {
        MovieDetailEntity(
            adult: adult,
            backdropPath: backdropPath,
            belongsToCollection: belongsToCollection?.toEntity,
            budget: budget,
            genres: genres.map { $0.toEntity },
            homepage: homepage,
            id: id,
            imdbID: imdbID,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            productionCompanies: productionCompanies.map { $0.toEntity },
            productionCountries: productionCountries.map { $0.toEntity },
            releaseDate: releaseDate,
            revenue: revenue,
            runtime: runtime,
            spokenLanguages: spokenLanguages.map { $0.toEntity },
            status: status,
            tagline: tagline,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}

// MARK: - Nested DTOs
struct GenreDTO: Decodable, Hashable {
    let id: Int
    let name: String
}

extension GenreDTO {
    var toEntity: GenreEntity {
        GenreEntity(id: id, name: name)
    }
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

extension ProductionCompanyDTO {
    var toEntity: ProductionCompanyEntity {
        ProductionCompanyEntity(
            id: id,
            logoPath: logoPath,
            name: name,
            originCountry: originCountry
        )
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

extension ProductionCountryDTO {
    var toEntity: ProductionCountryEntity {
        ProductionCountryEntity(iso3166_1: iso3166_1, name: name)
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

extension SpokenLanguageDTO {
    var toEntity: SpokenLanguageEntity {
        SpokenLanguageEntity(englishName: englishName, iso639_1: iso639_1, name: name)
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

extension BelongsToCollectionDTO {
    var toEntity: BelongsToCollectionEntity {
        BelongsToCollectionEntity(
            id: id,
            name: name,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }
}
