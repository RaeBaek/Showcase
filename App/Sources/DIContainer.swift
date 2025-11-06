//
//  DIContainer.swift
//  App
//
//  Created by 백래훈 on 11/6/25.
//

import NetworkLive

import HomeData
import HomeDomain
import HomePresentation

import DetailData
import DetailDomain
import DetailPresentation

final class DIContainer {
    let httpClient: TMDBClient

    init(httpClient: TMDBClient) {
        self.httpClient = httpClient
    }

    // Repository
    private func makeHomeRepository() -> HomeRepositoryImpl {
        return HomeRepositoryImpl(client: httpClient)
    }

    private func makeMovieDetailRepository() -> MovieDetailRepositoryImpl {
        return MovieDetailRepositoryImpl(client: httpClient)
    }
}

extension DIContainer {
    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        let repository = makeHomeRepository()
        return HomeViewModel(
            moviesUsecase: MoviesPagingUseCase(repository: repository),
            peopleUsecase: PeoplePagingUseCase(repository: repository),
            tvsUsecase: TVsPagingUseCase(repository: repository)
        )
    }

    @MainActor
    func makeMovieDetailViewModel(id: Int32) -> MovieDetailViewModel {
        let repository = makeMovieDetailRepository()
        return MovieDetailViewModel(
            id: id,
            useCase: MovieDetailUseCaseImpl(repository: repository)
        )
    }
}
