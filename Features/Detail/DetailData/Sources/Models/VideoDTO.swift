//
//  VideoDTO.swift
//  DetailData
//
//  Created by 백래훈 on 11/4/25.
//

import Foundation
import DetailDomain

struct VideoDTO: Codable {
    let id: Int
    let results: [VideoResultDTO]
}

extension VideoDTO {
    var toEntity: VideoEntity {
        VideoEntity(id: id, results: results.map { $0.toEntity })
    }
}

struct VideoResultDTO: Codable {
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

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official, id
        case publishedAt = "published_at"
    }
}

extension VideoResultDTO {
    var toEntity: VideoResultEntity {
        VideoResultEntity(
            iso639_1: iso639_1,
            iso3166_1: iso3166_1,
            name: name,
            key: key,
            site: site,
            size: size,
            type: type,
            official: official,
            publishedAt: publishedAt,
            id: id
        )
    }
}
