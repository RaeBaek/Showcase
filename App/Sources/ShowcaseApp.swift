//
//  ShowcaseApp.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import SwiftUI

import NetworkLive

import HomeData
import HomeDomain
import HomePresentation

import DetailData
import DetailDomain
import DetailPresentation

@main
struct ShowcaseApp: App {
    @State private var path = NavigationPath()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                let client = TMDBClient()
                let repository = HomeRepositoryImpl(client: client)
                let moviesUsecase = MoviesPagingUseCase(repository: repository)
                let peopleUsecase = PeoplePagingUseCase(repository: repository)
                let tvsUsecase = TVsPagingUseCase(repository: repository)
                let viewModel = HomeViewModel(
                    moviesUsecase: moviesUsecase,
                    peopleUsecase: peopleUsecase,
                    tvsUsecase: tvsUsecase
                )
                HomeView(viewModel: viewModel) { item in
                    path.append(item)
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .movieDetail(let id):
                        let client = TMDBClient()
                        let repository = MovieDetailRepositoryImpl(client: client)
                        let usecase = MovieDetailUseCaseImpl(repository: repository)
                        let viewModel = MovieDetailViewModel(id: id, useCase: usecase)
                        MovieDetailView(
                            viewModel: viewModel) { item in
                                path.append(item)
                            }
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}

public enum Route: Hashable {
    case movieDetail(id: Int32)
}
