//
//  HomeUseCaseImpl.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/25/25.
//

import Foundation

public final class HomeUseCaseImpl: HomeUseCase {

    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func movieModifyList() async throws -> [ModifyEntity] {
        try await self.repository.movieModifyList()
    }
    
    public func peopleModifyList() async throws -> [ModifyEntity] {
        try await self.repository.peopleModifyList()
    }
    
    public func tvModifyList() async throws -> [ModifyEntity] {
        try await self.repository.tvModifyList()
    }
    
    public func moviePopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularMovieEntity> {
        try await self.repository.moviePopularList(input)
    }
    
    public func peoplePopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularPeopleEntity> {
        try await self.repository.peoplePopularList(input)
    }
    
    public func tvPopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularTVEntity> {
        try await self.repository.tvPopularList(input)
    }

//    public func loadHomeFeed() async throws -> HomeFeedOutput {
//        async let movieTask = self.moviePopularList()
//        async let peopleTask = self.peoplePopularList()
//        async let tvTask = self.tvPopularList()
//
//        let movies = try await movieTask
//        let people = try await peopleTask
//        let tvs = try await tvTask
//
//        return HomeFeedOutput(
//            movies: movies,
//            people: people,
//            tvs: tvs
//        )
//    }
}
