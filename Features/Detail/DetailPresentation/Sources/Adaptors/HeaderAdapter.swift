//
//  HeaderAdapter.swift
//  DetailData
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

import Localization
import DetailDomain

public struct MovieHeaderAdapter: HeaderBackdropPresentable {
    private let info: MovieDetailInfoEntity

    public init(info: MovieDetailInfoEntity) {
        self.info = info
    }

    public var titleText: String {
        info.title
    }

    public var originalTitleText: String? {
        guard let originalTitle = info.originalTitle, originalTitle != titleText else { return nil }
        return originalTitle
    }

    public var ratingText: String {
        String(format: "★ %.1f (%d)", info.voteAverage, info.voteCount)
    }

    public var metaText: String {
        let year = info.releaseDate.map { String($0.prefix(4)) }
        let time = info.runtime.map { "\($0)\(L10n.MovieDetail.detailMinute)" }
        return [year, time].compactMap { $0 }.joined(separator: " · ")
    }

    public var genresText: String {
        info.genres.map(\.name).prefix(3).joined(separator: " · ")
    }

    public var posterURL: URL? {
        info.posterURL
    }

    public var backdropURL: URL? {
        info.backdropURL
    }

    public var overviewText: String {
        info.overview
    }
}

public struct TVHeaderAdapter: HeaderBackdropPresentable {
    private let info: TVDetailInfoEntity

    public init(info: TVDetailInfoEntity) {
        self.info = info
    }

    public var titleText: String {
        info.name
    }

    public var originalTitleText: String? {
        guard let originalName = info.originalName, originalName != titleText else { return nil }
        return originalName
    }

    public var ratingText: String {
        String(format: "★ %.1f (%d)", info.voteAverage, info.voteCount)
    }

    public var metaText: String {
        let air = info.airDateRangeText
        let season = "\(L10n.TVDetail.detailSeason) \(info.numberOfSeasons) • \(L10n.TVDetail.detailEpisode) \(info.numberOfEpisodes)"
        let runtime = info.runtimeText
        return [air, season, runtime].compactMap { $0 }.joined(separator: " · ")
    }

    public var genresText: String {
        info.genres.map(\.name).prefix(3).joined(separator: " · ")
    }

    public var posterURL: URL? {
        info.posterURL
    }

    public var backdropURL: URL? {
        info.backdropURL
    }

    public var overviewText: String {
        info.overview
    }
}
