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
import DetailDomain
import DetailPresentation
import StreamingPresentation

@main
struct ShowcaseApp: App {
    @StateObject private var navigator = AppNavigator()
    private let container = DIContainer(httpClient: TMDBClient())
    #if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
    @State private var similarMoviesPreview: SimilarMoviesReactNativePreview.Request?
    @State private var selectedSimilarMovieID: Int32?
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
                .sheet(item: $similarMoviesPreview, onDismiss: openSelectedSimilarMovie) { request in
                    SimilarMoviesReactNativePreview(request: request)
                }
                .onReceive(NotificationCenter.default.publisher(for: .init("ShowcaseSimilarMovieSelected"))) { notification in
                    guard let request = similarMoviesPreview,
                          notification.object as? String == request.id.uuidString,
                          let movieID = notification.userInfo?["movieID"] as? String,
                          let id = Int32(movieID),
                          request.movies.contains(where: { $0.id == Int(id) }) else { return }

                    selectedSimilarMovieID = id
                    similarMoviesPreview = nil
                }
                #endif
            }
        }
    }

    #if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
    private func openSelectedSimilarMovie() {
        guard let id = selectedSimilarMovieID else { return }
        selectedSimilarMovieID = nil
        navigator.push(.movieDetail(id: id))
    }
    #endif

    private var showSimilarMovies: (([SimilarItemEntity]) -> Void)? {
        #if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
        return { similarMoviesPreview = .init(mode: .fresh, movies: $0) }
        #else
        return nil
        #endif
    }

    private var showSimilarMoviesWithSharedRuntime: (([SimilarItemEntity]) -> Void)? {
        #if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
        return { similarMoviesPreview = .init(mode: .shared, movies: $0) }
        #else
        return nil
        #endif
    }
}
