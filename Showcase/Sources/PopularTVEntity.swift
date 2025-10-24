//
//  PopularTVEntity.swift
//  Showcase
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

struct PopularTVEntity: Identifiable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDs: [Int]?
    let id: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let firstAirDate: String?
    let name: String?
    let voteAverage: Double?
    let voteCount: Int?
}
