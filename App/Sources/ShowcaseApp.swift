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
import StreamingPresentation

@main
struct ShowcaseApp: App {
    @StateObject private var navigator = AppNavigator()
    private let container = DIContainer(httpClient: TMDBClient())
    #if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
    @State private var similarMoviesPreviewMode: SimilarMoviesReactNativePreview.Mode?
    #endif

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigator.path) {
                HomeView(viewModel: container.makeHomeViewModel()) { item in
                    navigator.push(item)
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .movieDetail(let id):
                        MovieDetailView(
                            viewModel: container.makeMovieDetailViewModel(id: id),
                            onShowSimilarMovies: showSimilarMovies,
                            onShowSimilarMoviesWithSharedRuntime: showSimilarMoviesWithSharedRuntime
                        ) { item in
                            navigator.push(item)
                        }
                        .background(EnableBackSwipeGesture())
                    case .personDetail(let id):
                        PeopleDetailView(viewModel: container.makePeopleDetailViewModel(id: id)) { item in
                            navigator.push(item)
                        }
                        .background(EnableBackSwipeGesture())
                    case .tvDetail(let id):
                        TVDetailView(viewModel: container.makeTVDetailViewModel(id: id)) { item in
                            navigator.push(item)
                        }
                        .background(EnableBackSwipeGesture())
                    case .hlsDemo:
                        HLSDemoPage(viewModel: container.makeHLSDemoViewModel())
                            .background(EnableBackSwipeGesture())
                    }
                }
                .preferredColorScheme(.dark)
                #if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
                .sheet(item: $similarMoviesPreviewMode) { mode in
                    SimilarMoviesReactNativePreview(mode: mode)
                }
                #endif
            }
        }
    }

    private var showSimilarMovies: (() -> Void)? {
        #if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
        return { similarMoviesPreviewMode = .fresh }
        #else
        return nil
        #endif
    }

    private var showSimilarMoviesWithSharedRuntime: (() -> Void)? {
        #if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
        return { similarMoviesPreviewMode = .shared }
        #else
        return nil
        #endif
    }
}
