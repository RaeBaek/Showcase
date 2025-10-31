//
//  PopularPeopleEntity.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

public struct PopularPeopleEntity: Identifiable {
    public let adult: Bool?
    public let gender: Int?
    public let id: Int
    public let knownFor: [KnownForEntity]?
    public let knownForDepartment: String?
    public let name: String?
    public let popularity: Double?
    public let profilePath: String?

    public init(
        adult: Bool?,
        gender: Int?,
        id: Int,
        knownFor: [KnownForEntity]?,
        knownForDepartment: String?,
        name: String?,
        popularity: Double?,
        profilePath: String?
    ) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownFor = knownFor
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.popularity = popularity
        self.profilePath = profilePath
    }

    public init(
        id: Int,
        name: String?,
    ) {
        self.id = id
        self.name = name
        self.adult = nil
        self.gender = nil
        self.knownFor = nil
        self.knownForDepartment = nil
        self.popularity = nil
        self.profilePath = nil
    }
}

public struct KnownForEntity {
    public let adult: Bool?
    public let backdropPath: String?
    public let genreIDs: [Int]?
    public let id: Int?
    public let mediaType: String?
    public let originalLanguage: String?
    public let originalTitle: String?
    public let overview: String?
    public let posterPath: String?
    public let releaseDate: String?
    public let title: String?
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?

    public init(
        adult: Bool?,
        backdropPath: String?,
        genreIDs: [Int]?,
        id: Int?,
        mediaType: String?,
        originalLanguage: String?,
        originalTitle: String?,
        overview: String?,
        posterPath: String?,
        releaseDate: String?,
        title: String?,
        video: Bool?,
        voteAverage: Double?,
        voteCount: Int?
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDs = genreIDs
        self.id = id
        self.mediaType = mediaType
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
