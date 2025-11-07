//
//  HomeView.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import SwiftUI
import NavigationInterface
import HomeDomain

public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    private let onNavigate: (Route) -> Void

    public init(
        viewModel: HomeViewModel,
        onNavigate: @escaping (Route) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNavigate = onNavigate
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                SectionView<PopularMovieEntity>(
                    title: "🎬 Movies",
                    items: viewModel.movies
                ) { item in
                    Task { await viewModel.onMovieAppear(item) }
                } onItemTap: { item in
                    onNavigate(.movieDetail(id: Int32(item.id)))
                }

                SectionView<PopularPeopleEntity>(
                    title: "🧑‍🤝‍🧑 People",
                    items: viewModel.people
                ) { item in
                    Task { await viewModel.onPeopleAppear(item) }
                } onItemTap: { item in
                    onNavigate(.personDetail(id: Int32(item.id)))
                }

                SectionView<PopularTVEntity>(
                    title: "📺 TVs",
                    items: viewModel.tvs
                ) { item in
                    Task { await viewModel.onTVAppear(item) }
                } onItemTap: { item in
//                    onNavigate(.movieDetail(id: Int32(item.id)))
                }
            }
            .padding(16)
        }
        .navigationTitle("Showcase")
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
