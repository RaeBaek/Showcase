//
//  PopularPeopleEntity.swift
//  Showcase
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

struct PopularPeopleEntity: Identifiable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownFor: [KnownForEntity]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?
}

struct KnownForEntity {
    let adult: Bool?
    let backdropPath: String?
    let genreIDs: [Int]?
    let id: Int?
    let mediaType: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}
