//
//  MovieDetailEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/1/25.
//

import Foundation

public struct MovieDetailEntity: Identifiable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollectionEntity?
    let budget: Int?
    let genres: [GenreEntity]
    let homepage: String?
    public let id: Int32
    let imdbID: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompanyEntity]
    let productionCountries: [ProductionCountryEntity]
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguageEntity]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    public init(
        adult: Bool,
        backdropPath: String?,
        belongsToCollection: BelongsToCollectionEntity?,
        budget: Int?,
        genres: [GenreEntity],
        homepage: String?,
        id: Int32,
        imdbID: String?,
        originalLanguage: String,
        originalTitle: String,
        overview: String,
        popularity: Double,
        posterPath: String?,
        productionCompanies: [ProductionCompanyEntity],
        productionCountries: [ProductionCountryEntity],
        releaseDate: String?,
        revenue: Int?,
        runtime: Int?,
        spokenLanguages: [SpokenLanguageEntity],
        status: String,
        tagline: String?,
        title: String,
        video: Bool,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.belongsToCollection = belongsToCollection
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.imdbID = imdbID
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.runtime = runtime
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

protocol DetailURLConvertible {
    var backdropURL: URL? { get }
    var posterURL: URL? { get }
}

extension MovieDetailEntity: DetailURLConvertible {
    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original/\(backdropPath)")
    }

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780/\(posterPath)")
    }
}

extension MovieDetailEntity {
    var toDetail: MovieDetailInfoEntity {
        MovieDetailInfoEntity(
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            voteCount: voteCount,
            genres: genres,
            runtime: runtime,
            backdropURL: backdropURL,
            posterURL: posterURL
        )
    }
}

public struct GenreEntity {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct ProductionCountryEntity {
    let iso3166_1: String
    let name: String

    public init(iso3166_1: String, name: String) {
        self.iso3166_1 = iso3166_1
        self.name = name
    }
}

public struct ProductionCompanyEntity {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String?

    public init(id: Int, logoPath: String?, name: String, originCountry: String?) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
}

public struct SpokenLanguageEntity {
    let englishName: String?
    let iso639_1: String
    let name: String?

    public init(englishName: String?, iso639_1: String, name: String?) {
        self.englishName = englishName
        self.iso639_1 = iso639_1
        self.name = name
    }
}


public struct BelongsToCollectionEntity {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?

    public init(id: Int, name: String, posterPath: String?, backdropPath: String?) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
}

public struct MovieDetailInfoEntity: Identifiable {
    public let id: Int32
    public let title: String
    public let originalTitle: String?
    public let overview: String
    public let releaseDate: String?
    public let voteAverage: Double
    public let voteCount: Int
    public let genres: [GenreEntity]
    public let runtime: Int?
    public let backdropURL: URL?
    public let posterURL: URL?

    public init(
        id: Int32,
        title: String,
        originalTitle: String?,
        overview: String,
        releaseDate: String?,
        voteAverage: Double,
        voteCount: Int,
        genres: [GenreEntity],
        runtime: Int?,
        backdropURL: URL?,
        posterURL: URL?
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.genres = genres
        self.runtime = runtime
        self.backdropURL = backdropURL
        self.posterURL = posterURL
    }
}

public struct CreditInfoEntity: Identifiable {
    public let id: Int
    public let name: String
    public let role: String?
    public let profileURL: URL?

    public init(id: Int, name: String, role: String?, profileURL: URL?) {
        self.id = id
        self.name = name
        self.role = role
        self.profileURL = profileURL
    }
}

public struct VideoItemEntity: Identifiable {
    public let id: String
    public let name: String
    public let site: String            // "YouTube"
    public let key: String             // youtube key
    public let type: String            // "Trailer" 등

    public init(id: String, name: String, site: String, key: String, type: String) {
        self.id = id
        self.name = name
        self.site = site
        self.key = key
        self.type = type
    }
}

public extension VideoItemEntity {
    var thumbnailURL: URL? {
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }

    var watchURL: URL? {
        return URL(string: "https://www.youtube.com/watch?v=\(key)")!
    }
}

public struct SimilarItemEntity: Identifiable {
    public let id: Int
    public let title: String?
    public let posterURL: URL?

    public init(id: Int, title: String?, posterURL: URL?) {
        self.id = id
        self.title = title
        self.posterURL = posterURL
    }
}

extension SimilarItemEntity: HorizontalContentDisplayable {
    public var titleText: String {
        return title ?? ""
    }
    
    public var infoText: String? {
        return nil
    }
}
