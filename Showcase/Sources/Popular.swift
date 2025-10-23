//
//  Popular.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation

struct PopularListResponse<T: Decodable>: Decodable {
    let page: Int?
    let results: [T]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: Popular Movie
struct PopularMovieDTO: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult, id, overview, popularity, title, video
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension PopularMovieDTO {
    var toEntity: PopularMovieEntity {
        PopularMovieEntity(
            adult: adult,
            backdropPath: backdropPath,
            genreIds: genreIds,
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

struct PopularMovieEntity: Identifiable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}

// MARK: Popular People
struct PopularPeopleDTO: Decodable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownFor: [KnownForDTO]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name, popularity
        case profilePath = "profile_path"
    }
}

extension PopularPeopleDTO {
    var toEntity: PopularPeopleEntity {
        PopularPeopleEntity(
            adult: adult,
            gender: gender,
            id: id,
            knownFor: knownFor?.map { $0.toEntity },
            knownForDepartment: knownForDepartment,
            name: name,
            popularity: popularity,
            profilePath: profilePath
        )
    }
}

struct PopularPeopleEntity: Identifiable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownFor: [KnownForEntity]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?
}

struct KnownForDTO: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDs: [Int]?
    let id: Int?
    let mediaType: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult, id, overview, title, video
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension KnownForDTO {
    var toEntity: KnownForEntity {
        KnownForEntity(
            adult: adult,
            backdropPath: backdropPath,
            genreIDs: genreIDs,
            id: id,
            mediaType: mediaType,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}

struct KnownForEntity {
    let adult: Bool?
    let backdropPath: String?
    let genreIDs: [Int]?
    let id: Int?
    let mediaType: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}

// MARK: - Popular TV
struct PopularTVDTO: Decodable {
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
}

extension PopularTVDTO {
    var toEntity: PopularTVEntity {
        PopularTVEntity(
            adult: adult,
            backdropPath: backdropPath,
            genreIDs: genreIDs,
            id: id,
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

struct PopularTVEntity: Identifiable {
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
}
