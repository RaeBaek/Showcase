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
                            onShowSimilarMovies: { showSimilarMovies(movieID: id, page: $0, mode: .fresh) },
                            onShowSimilarMoviesWithSharedRuntime: { showSimilarMovies(movieID: id, page: $0, mode: .shared) }
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
                        .presentationDragIndicator(.visible)
                        .presentationBackground(Color(white: 22.0 / 255.0))
                        .onDisappear { request.pagination.cancel() }
                }
                .onReceive(NotificationCenter.default.publisher(for: .init("ShowcaseSimilarMovieSelected"))) { notification in
                    guard let request = similarMoviesPreview,
                          let id = SimilarMovieSelection.movieID(
                              from: notification,
                              requestID: request.id,
                              allowedMovieIDs: request.pagination.allowedMovieIDs
                          ) else { return }

                    request.pagination.cancel()
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

    private func showSimilarMovies(
        movieID: Int32,
        page: SimilarMoviesPage,
        mode: SimilarMoviesReactNativePreview.Mode
    ) {
        similarMoviesPreview?.pagination.cancel()
        let pagination = SimilarMoviesPagination(
            movieID: movieID,
            language: container.language,
            initialPage: page,
            useCase: container.makeMovieDetailUseCase()
        )
        similarMoviesPreview = .init(mode: mode, initialPage: page, pagination: pagination)
    }
}

enum SimilarMovieSelection {
    static func movieID(
        from notification: Notification,
        requestID: UUID,
        allowedMovieIDs: Set<Int>
    ) -> Int32? {
        guard notification.object as? String == requestID.uuidString,
              let movieID = notification.userInfo?["movieID"] as? String,
              let id = Int32(movieID),
              allowedMovieIDs.contains(Int(id)) else { return nil }

        return id
    }
}
