//
//  PopularMovieEntity.swift
//  Showcase
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

struct PopularMovieEntity: Identifiable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}
