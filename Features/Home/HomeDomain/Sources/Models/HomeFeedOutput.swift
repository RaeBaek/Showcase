//
//  HomeFeedOutput.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/27/25.
//

import Foundation

public struct HomeFeedOutput {
    public let movies: [PopularMovieEntity]
    public let people: [PopularPeopleEntity]
    public let tvs: [PopularTVEntity]
}
