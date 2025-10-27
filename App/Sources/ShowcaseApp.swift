//
//  ShowcaseApp.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import SwiftUI

import ShowNetwork
import HomeData
import HomeDomain
import HomePresentation

@main
struct ShowcaseApp: App {
    var body: some Scene {
        WindowGroup {
            let client = TMDBClient()
            let repository = HomeRepositoryImpl(client: client)
            let useCase = HomeUseCaseImpl(repository: repository)
            let viewModel = HomeViewModel(useCase: useCase)
            HomeView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
