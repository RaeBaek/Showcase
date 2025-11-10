//
//  TVInfoEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

public struct TVDetailInfoEntity: Identifiable {
    public let id: Int32
    public let name: String
    public let originalName: String?
    public let tagline: String?

    public let posterPath: String?
    public let backdropPath: String?

    public let firstAirDate: String?
    public let lastAirDate: String?
    public let status: String
    public let inProduction: Bool
    public let numberOfSeasons: Int
    public let numberOfEpisodes: Int
    public let episodeRunTime: [Int]?

    public let createdBy: [CreatorEntity]
    public let networks: [NetworkEntity]
    public let homepage: String?

    public let overview: String
    public let genres: [GenreEntity]
    public let originCountry: [String]?
    public let originalLanguage: String

    public let voteAverage: Double
    public let voteCount: Int

    // MARK: - Derived
    public var year: String? {
        guard let d = firstAirDate, d.count >= 4 else { return nil }
        return String(d.prefix(4))
    }

    public var airDateRangeText: String {
        let start = year ?? "—"
        let end: String = {
            guard let last = lastAirDate, last.count >= 4 else {
                return inProduction ? "현재" : "—"
            }
            return String(last.prefix(4))
        }()
        return start == end ? start : "\(start) ~ \(end)"
    }

    public var runtimeText: String? {
        guard let r = episodeRunTime, !r.isEmpty else { return nil }
        if let min = r.min(), let max = r.max() {
            return min == max ? "\(min)분" : "\(min)–\(max)분"
        }
        return nil
    }

    public var genresText: String {
        genres.map(\.name).joined(separator: " · ")
    }

    public var creatorsText: String {
        let names = createdBy.map(\.name)
        return names.prefix(3).joined(separator: ", ")
    }

    public var seasonSummaryText: String {
        "시즌 \(numberOfSeasons) • 에피소드 \(numberOfEpisodes)"
    }

    public var ratingText: String {
        let avg = String(format: "%.1f", voteAverage)
        return "★ \(avg) (\(voteCount))"
    }

    public var posterURL: URL? {
        guard let p = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(p)")
    }

    public var backdropURL: URL? {
        guard let p = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(p)")
    }

    public var statusBadge: TVStatusBadge {
        switch status.lowercased() {
        case "returning series": return .returning
        case "ended": return .ended
        case "planned": return .planned
        case "in production": return .inProduction
        default: return .unknown
        }
    }
}

public enum TVStatusBadge {
    case returning, ended, planned, inProduction, unknown
}
