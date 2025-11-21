//
//  MoviesPagingUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/27/25.
//

import Foundation

public final class MoviesPagingUseCase: BasePagingUseCase<PopularMovieEntity> {

    private let language: String

    public init(repository: HomeRepository, language: String) {
        self.language = language
        super.init() { input in
            try await repository.moviePopularList(input)
        }
    }

    public func loadFirstMovies() async throws {
        try await loadFirst()
    }

    public func loadMoreMoviesIfNeeded(currentItem: PopularMovieEntity) async {
        await loadMoreIfNeeded(currentItem: currentItem, threshold: 5)
    }

    public override func makeParams(page: Int) -> HomeFeedInput {
        return HomeFeedInput(page: page, language: language)
    }
}
