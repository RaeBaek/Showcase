//
//  PersonCombineCreditsEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/6/25.
//

import Foundation

public struct PersonCombineCreditsEntity {
    let id: Int
    let cast: [PersonCreditEntity]
    let crew: [PersonCreditEntity]

    public init(id: Int, cast: [PersonCreditEntity], crew: [PersonCreditEntity]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }
}

public struct PersonCreditEntity {
    // 공통
    let adult: Bool
    let backdropPath: String?
    let genreIDs: [Int]?
    let id: Int
    let originalLanguage: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let character: String?
    let voteAverage: Double?
    let voteCount: Int?
    let creditID: String
    let department: String?
    let job: String?
    let mediaType: MediaType

    // Movie 전용
    let title: String?
    let originalTitle: String?
    let releaseDate: String?
    let video: Bool?
    let order: Int?

    // TV 전용
    let name: String?
    let originalName: String?
    let firstAirDate: String?
    let originCountry: [String]?
    let episodeCount: Int?
    let firstCreditAirDate: String?

    public init(
        adult: Bool,
        backdropPath: String?,
        genreIDs: [Int]?,
        id: Int,
        originalLanguage: String,
        overview: String,
        popularity: Double,
        posterPath: String?,
        character: String?,
        voteAverage: Double?,
        voteCount: Int?,
        creditID: String,
        department: String?,
        job: String?,
        mediaType: MediaType,
        title: String?,
        originalTitle: String?,
        releaseDate: String?,
        video: Bool?,
        order: Int?,
        name: String?,
        originalName: String?,
        firstAirDate: String?,
        originCountry: [String]?,
        episodeCount: Int?,
        firstCreditAirDate: String?
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDs = genreIDs
        self.id = id
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.character = character
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.creditID = creditID
        self.department = department
        self.job = job
        self.mediaType = mediaType
        self.title = title
        self.originalTitle = originalTitle
        self.releaseDate = releaseDate
        self.video = video
        self.order = order
        self.name = name
        self.originalName = originalName
        self.firstAirDate = firstAirDate
        self.originCountry = originCountry
        self.episodeCount = episodeCount
        self.firstCreditAirDate = firstCreditAirDate
    }
}

extension PersonCreditEntity {
    public func toKnownForItem() -> KnownForItem? {
        // media
        let media = Media(raw: mediaType.rawValue)
        // title normalization
        let titleText: String? = {
            switch mediaType {
            case .movie:
                return title ?? originalTitle
            case .tv:
                return name ?? originalName
            }
        }()
        guard let titleText, let media else { return nil }

        // year nomarlization
        let dateStr: String? = (mediaType == .movie) ? releaseDate : firstAirDate
        let yearText: String? = dateStr.flatMap { string in
            let comps = string.split(separator: "-")
            return comps.first.map { String($0) }
        }

        // image: 포스터 없으면 백드롭
        let poster = posterPath ?? backdropPath

        return KnownForItem(
            id: id,
            title: titleText,
            posterPath: poster,
            year: yearText,
            media: media
        )
    }
}

extension Array where Element == PersonCreditEntity {
    public func toKnownForItems() -> [KnownForItem] {
        // 매핑
        let mapped = self.compactMap { $0.toKnownForItem() }
        // 중복 제거
        var seen = Set<Int>()
        var unique: [KnownForItem] = []
        for item in mapped {
            if seen.insert(item.id).inserted {
                unique.append(item)
            }
        }

        func yearInt(_ year: String?) -> Int {
            Int(year ?? "") ?? -1
        }

        return unique.sorted {
            return yearInt($0.year) > yearInt($1.year)
        }
    }
}

// MARK: - Enum
public enum MediaType: String, Codable {
    case movie
    case tv
}
