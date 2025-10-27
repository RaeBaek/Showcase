//
//  MoviesPagingUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/27/25.
//

import Foundation

public final class MoviesPagingUseCase: BasePagingUseCase<PopularMovieEntity> {

    public init(repository: HomeRepository) {
        super.init(fetch: { next in
            try await repository.moviePopularList(.init(page: next, language: "ko-KR"))
        })
    }

    public func loadFirstMovies() async throws {
        try await loadFirst()
    }

    public func loadMoreMoviesIfNeeded(currentItem: PopularMovieEntity) async {
        await loadMoreIfNeeded(currentItem: currentItem, threshold: 5)
    }
}
