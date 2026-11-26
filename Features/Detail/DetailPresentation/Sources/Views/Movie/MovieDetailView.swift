//
//  MovieDetailView.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI

import DesignSystem
import Localization
import NavigationInterface
import DetailDomain

public struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    private let onShowSimilarMovies: ((SimilarMoviesPage) -> Void)?
    private let onShowSimilarMoviesWithSharedRuntime: ((SimilarMoviesPage) -> Void)?
    private let onNavigate: (Route) -> Void

    public init(
        viewModel: MovieDetailViewModel,
        onShowSimilarMovies: ((SimilarMoviesPage) -> Void)? = nil,
        onShowSimilarMoviesWithSharedRuntime: ((SimilarMoviesPage) -> Void)? = nil,
        onNavigate: @escaping (Route) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onShowSimilarMovies = onShowSimilarMovies
        self.onShowSimilarMoviesWithSharedRuntime = onShowSimilarMoviesWithSharedRuntime
        self.onNavigate = onNavigate
    }

    public var body: some View {
        Group {
            switch viewModel.movieDetailState.state {
            case .idle, .loading:
                LoadingSkeleton()
                    .onAppear {
                        Task {
                            await viewModel.load()
                        }
                    }
            case .failed(let message):
                VStack(spacing: 12) {
                    Image(systemName: "wifi.exclamationmark")
                    Text(message)
                        .font(.subheadline)
                    Button(L10n.Error.errorRetry) {
                        Task {
                            await viewModel.load()
                        }
                    }
                }
                .foregroundStyle(.secondary)
                .padding(.top, 80)
            case .loaded:
                if let adapter = viewModel.movieDetailState.adapter {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            HeaderBackdrop(model: adapter)
                            ActionBar()
                            OverviewSection(
                                text: adapter.overviewText,
                                expanded: Binding(
                                    get: {
                                        viewModel.movieDetailState.showFullOverview
                                    },
                                    set: { _ in
                                        viewModel.toggleOverviewExpanded()
                                    })
                            )
                            if !viewModel.movieDetailState.credits.isEmpty {
                                CreditSection(credits: viewModel.movieDetailState.credits) { credit in
                                    onNavigate(.personDetail(id: Int32(credit.personID)))
                                }
                            }
                            if !viewModel.movieDetailState.videos.isEmpty {
                                VideoSection(videos: viewModel.movieDetailState.videos)
                            }
                            if let page = viewModel.movieDetailState.similarMoviesPage, !page.items.isEmpty {
                                HorizontalContentSection(title: L10n.MovieTVDetail.detailSimilarPiece, items: page.items) { item in
                                    onNavigate(.movieDetail(id: Int32(item.id)))
                                } footer: { _ in }
                                if let onShowSimilarMovies {
                                    Button(L10n.Common.commonMore) {
                                        onShowSimilarMovies(page)
                                    }
                                    .tint(.white)
                                    .padding(.top, 8)
                                    .padding(.horizontal, 16)
                                }
                                if let onShowSimilarMoviesWithSharedRuntime {
                                    Button("더보기 (런타임 재사용)") {
                                        onShowSimilarMoviesWithSharedRuntime(page)
                                    }
                                    .tint(.white)
                                    .padding(.top, 8)
                                    .padding(.horizontal, 16)
                                }
                            }
                            Spacer(minLength: 40)
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                }
            }
        }
        .customBackToolbar()
    }
}
