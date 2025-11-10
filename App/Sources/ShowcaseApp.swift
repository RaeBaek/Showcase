//
//  ShowcaseApp.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import SwiftUI

import NavigationInterface
import NetworkLive

import HomePresentation
import DetailPresentation

@main
struct ShowcaseApp: App {
    @StateObject private var navigator = AppNavigator()
    private let container = DIContainer(httpClient: TMDBClient())

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigator.path) {
                HomeView(viewModel: container.makeHomeViewModel()) { item in
                    navigator.push(item)
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .movieDetail(let id):
                        MovieDetailView(viewModel: container.makeMovieDetailViewModel(id: id)) { item in
                            navigator.push(item)
                        }
                    case .personDetail(let id):
                        PeopleDetailView(viewModel: container.makePeopleDetailViewModel(id: id)) { item in
                            navigator.push(item)

                        }
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
