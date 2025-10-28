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

@main
struct ShowcaseApp: App {
    var body: some Scene {
        WindowGroup {
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
            HomeView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
