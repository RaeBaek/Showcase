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
    @State private var selectedMovieID: Int32? = nil   // ✅ 선택된 영화 ID 상태

    var body: some Scene {
        WindowGroup {
            NavigationStack {
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
                HomeView(viewModel: viewModel) { id in
                    selectedMovieID = id
                }
                .navigationDestination(item: $selectedMovieID) { id in
                    let client = TMDBClient()
                    let repository = MovieDetailRepositoryImpl(client: client)
                    let usecase = MovieDetailUseCaseImpl(repository: repository)
                    let viewModel = MovieDetailViewModel(id: id, useCase: usecase)
                    MovieDetailView(viewModel: viewModel)

                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
