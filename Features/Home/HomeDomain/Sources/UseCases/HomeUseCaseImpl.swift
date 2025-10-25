//
//  HomeUseCaseImpl.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/25/25.
//

import Foundation

final class HomeUseCaseImpl: HomeUseCase {

    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func movieModifyList() async throws -> [ModifyEntity] {
        try await self.repository.movieModifyList()
    }
    
    func peopleModifyList() async throws -> [ModifyEntity] {
        try await self.repository.peopleModifyList()
    }
    
    func tvModifyList() async throws -> [ModifyEntity] {
        try await self.repository.tvModifyList()
    }
    
    func moviePopularList() async throws -> [PopularMovieEntity] {
        try await self.repository.moviePopularList()
    }
    
    func peoplePopularList() async throws -> [PopularPeopleEntity] {
        try await self.repository.peoplePopularList()
    }
    
    func tvPopularList() async throws -> [PopularTVEntity] {
        try await self.repository.tvPopularList()
    }
}
