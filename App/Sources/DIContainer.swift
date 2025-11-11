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

    private func makePeopleDetailRepository() -> PeopleDetailRepositoryImpl {
        return PeopleDetailRepositoryImpl(client: httpClient)
    }

    private func makeTVDetailRepository() -> TVDetailRepositoryImpl {
        return TVDetailRepositoryImpl(client: httpClient)
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

    @MainActor
    func makePeopleDetailViewModel(id: Int32) -> PeopleDetailViewModel {
        let repository = makePeopleDetailRepository()
        return PeopleDetailViewModel(
            id: id,
            usecase: PeopleDetailUseCaseImpl(reposiotry: repository)
        )
    }

    @MainActor
    func makeTVDetailViewModel(id: Int32) -> TVDetailViewModel {
        let repository = makeTVDetailRepository()
        return TVDetailViewModel(
            id: id,
            useCase: TVDetailUseCaseImpl(repository: repository)
        )
    }
}
