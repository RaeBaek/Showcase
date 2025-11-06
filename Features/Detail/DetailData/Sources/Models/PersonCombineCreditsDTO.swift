//
//  PersonCombineCreditsDTO.swift
//  DetailDomain
//
//  Created by 백래훈 on 11/6/25.
//

import Foundation
import DetailDomain

struct PersonCombineCreditsDTO: Decodable {
    let id: Int
    let cast: [PersonCreditDTO]
    let crew: [PersonCreditDTO]
}

extension PersonCombineCreditsDTO {
    var toEntity: PersonCombineCreditsEntity {
        PersonCombineCreditsEntity(
            id: id,
            cast: cast.map { $0.toEntity },
            crew: crew.map { $0.toEntity }
        )
    }
}

struct PersonCreditDTO: Decodable {
    // 공통
    let adult: Bool
    let backdropPath: String?
    let genreIDs: [Int]?
    let id: Int
    let originalLanguage: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let character: String
    let voteAverage: Double?
    let voteCount: Int?
    let creditID: String
    let department: String?
    let job: String?
    let mediaType: MediaType

    // Movie 전용
    let title: String?
    let originalTitle: String?
    let releaseDate: String?
    let video: Bool?
    let order: Int?

    // TV 전용
    let name: String?
    let originalName: String?
    let firstAirDate: String?
    let originCountry: [String]?
    let episodeCount: Int?
    let firstCreditAirDate: String?

    enum CodingKeys: String, CodingKey {
        case adult, id, overview, popularity, character, department, job, title, video, order, name
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case firstCreditAirDate = "first_credit_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case creditID = "credit_id"
        case episodeCount = "episode_count"
        case mediaType = "media_type"
    }
}

extension PersonCreditDTO {
    var toEntity: PersonCreditEntity {
        PersonCreditEntity(
            adult: adult,
            backdropPath: backdropPath,
            genreIDs: genreIDs,
            id: id,
            originalLanguage: originalLanguage,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            character: character,
            voteAverage: voteAverage,
            voteCount: voteCount,
            creditID: creditID,
            department: department,
            job: job,
            mediaType: mediaType,
            title: title,
            originalTitle: originalTitle,
            releaseDate: releaseDate,
            video: video,
            order: order,
            name: name,
            originalName: originalName,
            firstAirDate: firstAirDate,
            originCountry: originCountry,
            episodeCount: episodeCount,
            firstCreditAirDate: firstCreditAirDate
        )
    }
}
