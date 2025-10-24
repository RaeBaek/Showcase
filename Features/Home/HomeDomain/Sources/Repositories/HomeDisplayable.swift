//
//  HomeDisplayable.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation

protocol HomeDisplayable: Identifiable {
    var displayTitle: String { get }
    var imagePath: String? { get }
}

extension HomeDisplayable {
    var imageURL: URL? {
        guard let path = imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500" + path)
    }
}

// Movie
extension PopularMovieEntity: HomeDisplayable {
    var displayTitle: String { self.title ?? "" }
    var imagePath: String? { self.posterPath }

}

extension PopularPeopleEntity: HomeDisplayable {
    var displayTitle: String { self.name ?? "" }
    var imagePath: String? { self.profilePath }
}

extension PopularTVEntity: HomeDisplayable {
    var displayTitle: String { self.originalName ?? "" }
    var imagePath: String? { self.posterPath }
}
