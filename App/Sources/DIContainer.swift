//
//  DIContainer.swift
//  App
//
//  Created by 백래훈 on 11/6/25.
//

import Localization

import NetworkLive

import HomeData
import HomeDomain
import HomePresentation

import DetailData
import DetailDomain
import DetailPresentation

import StreamingData
import StreamingDomain
import StreamingPresentation

final class DIContainer {

    let httpClient: TMDBClient
    let language: String

    init(httpClient: TMDBClient, language: String = L10n.current) {
        self.httpClient = httpClient
        self.language = language
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

    private func makeStreamingRepository() -> HLSStreamRepositoryImpl {
        return HLSStreamRepositoryImpl()
    }
}

extension DIContainer {
    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        let repository = makeHomeRepository()
        return HomeViewModel(
            moviesUsecase: MoviesPagingUseCase(repository: repository, language: language),
            peopleUsecase: PeoplePagingUseCase(repository: repository, language: language),
            tvsUsecase: TVsPagingUseCase(repository: repository, language: language)
        )
    }

    @MainActor
    func makeMovieDetailViewModel(id: Int32) -> MovieDetailViewModel {
        let repository = makeMovieDetailRepository()
        return MovieDetailViewModel(
            id: id,
            language: language,
            useCase: MovieDetailUseCaseImpl(repository: repository)
        )
    }

    @MainActor
    func makePeopleDetailViewModel(id: Int32) -> PeopleDetailViewModel {
        let repository = makePeopleDetailRepository()
        return PeopleDetailViewModel(
            id: id,
            language: language,
            usecase: PeopleDetailUseCaseImpl(repository: repository)
        )
    }

    @MainActor
    func makeTVDetailViewModel(id: Int32) -> TVDetailViewModel {
        let repository = makeTVDetailRepository()
        return TVDetailViewModel(
            id: id,
            language: language,
            useCase: TVDetailUseCaseImpl(repository: repository)
        )
    }

    func makeHLSDemoViewModel() -> HLSDemoViewModel {
        let repository = makeStreamingRepository()
        return HLSDemoViewModel(fetchStreamsUseCase: repository)
    }
}
