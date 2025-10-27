//
//  HomeView.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import SwiftUI
import HomeDomain

public struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SectionView<PopularMovieEntity>(
                        title: "🎬 Movies",
                        items: viewModel.movies.items,
                    ) { item in
                        Task { await viewModel.loadNextMoviesIfNeeded(appearing: item)}
                    }
                    SectionView<PopularPeopleEntity>(
                        title: "🧑‍🤝‍🧑 Peoples",
                        items: viewModel.people.items
                    ) { item in
                        Task { await viewModel.loadNextPeopleIfNeeded(appearing: item)}
                    }
                    SectionView<PopularTVEntity>(
                        title: "📺 TVs",
                        items: viewModel.tvs.items
                    ) { item in
                        Task { await viewModel.loadNextTVsIfNeeded(appearing: item)}
                    }
                }
                .padding(16)
            }
            .navigationTitle("Showcase")
        }
        .task {
            await viewModel.firstLoad()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView().scaleEffect(1.2)
            }
        }
        .alert("에러", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("닫기") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
