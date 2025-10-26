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
    
    public func moviePopularList() async throws -> [PopularMovieEntity] {
        try await self.repository.moviePopularList()
    }
    
    public func peoplePopularList() async throws -> [PopularPeopleEntity] {
        try await self.repository.peoplePopularList()
    }
    
    public func tvPopularList() async throws -> [PopularTVEntity] {
        try await self.repository.tvPopularList()
    }
}
