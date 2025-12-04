//
//  HomeView.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import SwiftUI

import Localization
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
                    title: "🎬 \(L10n.Home.sectionMovies)",
                    items: viewModel.movies
                ) { item in
                    Task { await viewModel.onMovieAppear(item) }
                } onItemTap: { item in
                    onNavigate(.movieDetail(id: Int32(item.id)))
                }

                SectionView<PopularPeopleEntity>(
                    title: "🧑‍🤝‍🧑 \(L10n.Home.sectionPeople)",
                    items: viewModel.people
                ) { item in
                    Task { await viewModel.onPeopleAppear(item) }
                } onItemTap: { item in
                    onNavigate(.personDetail(id: Int32(item.id)))
                }

                SectionView<PopularTVEntity>(
                    title: "📺 \(L10n.Home.sectionTvs)",
                    items: viewModel.tvs
                ) { item in
                    Task { await viewModel.onTVAppear(item) }
                } onItemTap: { item in
                    onNavigate(.tvDetail(id: Int32(item.id)))
                }
            }
            .padding(16)
        }
        .navigationTitle("Showcase")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onNavigate(.hlsDemo)
                } label: {
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .imageScale(.large)
                }
                .tint(.white)
            }
        }
        .task {
            if viewModel.movies.isEmpty && viewModel.people.isEmpty && viewModel.tvs.isEmpty {
                await viewModel.firstLoad()
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
