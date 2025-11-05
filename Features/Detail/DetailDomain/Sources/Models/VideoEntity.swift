//
//  VideoEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/4/25.
//

import Foundation

public struct VideoEntity {
    let id: Int
    let results: [VideoResultEntity]

    public init(id: Int, results: [VideoResultEntity]) {
        self.id = id
        self.results = results
    }
}

public struct VideoResultEntity {
    let iso639_1: String
    let iso3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String

    public init(
        iso639_1: String,
        iso3166_1: String,
        name: String,
        key: String,
        site: String,
        size: Int,
        type: String,
        official: Bool,
        publishedAt: String,
        id: String
    ) {
        self.iso639_1 = iso639_1
        self.iso3166_1 = iso3166_1
        self.name = name
        self.key = key
        self.site = site
        self.size = size
        self.type = type
        self.official = official
        self.publishedAt = publishedAt
        self.id = id
    }
}

extension VideoResultEntity {
    var toVideoItemEntity: VideoItemEntity {
        VideoItemEntity(
            id: id,
            name: name,
            site: site,
            key: key,
            type: type
        )
    }
}
