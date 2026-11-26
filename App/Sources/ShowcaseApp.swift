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
    @State private var similarMoviesPreview: SimilarMoviesReactNativePreview.Request?
    @State private var selectedSimilarMovieID: Int32?

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
                .sheet(item: $similarMoviesPreview, onDismiss: openSelectedSimilarMovie) { request in
                    SimilarMoviesReactNativePreview(request: request)
                }
                .onReceive(NotificationCenter.default.publisher(for: .init("ShowcaseSimilarMovieSelected"))) { notification in
                    guard let request = similarMoviesPreview,
                          let id = SimilarMovieSelection.movieID(
                              from: notification,
                              requestID: request.id,
                              allowedMovieIDs: request.initialPage.items.map(\.id)
                          ) else { return }

                    selectedSimilarMovieID = id
                    similarMoviesPreview = nil
                }
            }
        }
    }

    private func openSelectedSimilarMovie() {
        guard let id = selectedSimilarMovieID else { return }
        selectedSimilarMovieID = nil
        navigator.push(.movieDetail(id: id))
    }

    private var showSimilarMovies: ((SimilarMoviesPage) -> Void)? {
        return { similarMoviesPreview = .init(mode: .fresh, initialPage: $0) }
    }

    private var showSimilarMoviesWithSharedRuntime: ((SimilarMoviesPage) -> Void)? {
        return { similarMoviesPreview = .init(mode: .shared, initialPage: $0) }
    }
}

enum SimilarMovieSelection {
    static func movieID(
        from notification: Notification,
        requestID: UUID,
        allowedMovieIDs: [Int]
    ) -> Int32? {
        guard notification.object as? String == requestID.uuidString,
              let movieID = notification.userInfo?["movieID"] as? String,
              let id = Int32(movieID),
              allowedMovieIDs.contains(Int(id)) else { return nil }

        return id
    }
}
