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
    private let onMovieSelected: (Int32) -> Void

    public init(viewModel: HomeViewModel,
                onMovieSelected: @escaping (Int32) -> Void) {
        self.viewModel = viewModel
        self.onMovieSelected = onMovieSelected
    }

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SectionView<PopularMovieEntity>(
                        title: "🎬 Movies",
                        items: viewModel.movies
                    ) { item in
                        Task { await viewModel.onMovieAppear(item) }
                        Button(action: {
                            onMovieSelected(Int32(item.id))
                        }) {
                            Text(item.displayTitle)

                        }
                    }

                    SectionView<PopularPeopleEntity>(
                        title: "🧑‍🤝‍🧑 People",
                        items: viewModel.people
                    ) { item in
                        Task { await viewModel.onPeopleAppear(item) }
                    }

                    SectionView<PopularTVEntity>(
                        title: "📺 TVs",
                        items: viewModel.tvs
                    ) { item in
                        Task { await viewModel.onTVAppear(item) }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Showcase")
        }
        .task {
            await viewModel.firstLoad()
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
