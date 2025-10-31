//
//  HomeDisplayable.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation

public protocol HomeDisplayable: Identifiable {
    var displayTitle: String { get }
    var imagePath: String? { get }
}

extension HomeDisplayable {
    public var imageURL: URL? {
        guard let path = imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500" + path)
    }
}

// Movie
extension PopularMovieEntity: HomeDisplayable {
    public var displayTitle: String { self.title ?? "" }
    public var imagePath: String? { self.posterPath }

}

extension PopularPeopleEntity: HomeDisplayable {
    public var displayTitle: String { self.name ?? "" }
    public var imagePath: String? { self.profilePath }
}

extension PopularTVEntity: HomeDisplayable {
    public var displayTitle: String { self.originalName ?? "" }
    public var imagePath: String? { self.posterPath }
}
