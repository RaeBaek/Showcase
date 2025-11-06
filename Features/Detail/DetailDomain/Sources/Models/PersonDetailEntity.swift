//
//  PersonDetailEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/6/25.
//

import Foundation

struct PersonDetailEntity: Identifiable, Hashable{
    public let id: Int
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

public struct KnownForItem: Identifiable, Hashable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let yearText: String?
    public let media: Media
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
