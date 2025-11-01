//
//  MovieDetailEntity.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/1/25.
//

import Foundation

public struct MovieDetailEntity {
    public let id: Int
    public let title: String
    public let originalTitle: String?
    public let overview: String
    public let releaseDate: String?
    public let voteAverage: Double
    public let genres: [String]
    public let runtime: Int?
    public let backdropURL: URL?
    public let posterURL: URL?
}

public struct CreditPersonEntity: Identifiable {
    public let id: Int
    public let name: String
    public let role: String?           // character or job
    public let profileURL: URL?
}

public struct VideoItemEntity: Identifiable {
    public let id: String
    public let name: String
    public let site: String            // "YouTube"
    public let key: String             // youtube key
    public let type: String            // "Trailer" 등
}

public struct SimilarMovieEntity: Identifiable {
    public let id: Int
    let title: String
    let posterURL: URL?
}
