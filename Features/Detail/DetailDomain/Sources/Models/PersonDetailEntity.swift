//
//  PersonDetailEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/6/25.
//

import Foundation

public struct PersonDetailEntity: Identifiable, Hashable {
    public let id: Int32
    public let name: String
    public let profilePath: String?
    public let knownForDepartment: String?
    public let birthday: String?
    public let deathday: String?
    public let placeOfBirth: String?
    public let homepage: String?
    public let popularity: Double
    public let biography: String?
}

extension PersonDetailEntity {
    public var profileURL: URL? {
        guard let profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(profilePath)")
    }
}

public struct KnownForItem: Identifiable, Hashable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let year: String?
    public let media: Media
}

extension KnownForItem {
    public var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(posterPath)")
    }
}

public enum Media {
    case movie
    case tv
}


extension Media {
    init?(raw: String?) {
        switch raw?.lowercased() {
        case "movie":
            self = .movie
        case "tv":
            self = .tv
        default:
            return nil
        }
    }
}
