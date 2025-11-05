//
//  HomeView.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import SwiftUI
import HomeDomain

//public enum Route: Hashable {
//    case movieDetail(id: Int32)
//}

public struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel
//    private let onMovieSelected: (Int32) -> Void
    private let onNavigate: (Route) -> Void

    public init(
        viewModel: HomeViewModel,
//        onMovieSelected: @escaping (Int32) -> Void
        onNavigate: @escaping (Route) -> Void
    ) {
        self.viewModel = viewModel
//        self.onMovieSelected = onMovieSelected
        self.onNavigate = onNavigate
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionView(
                    title: "🎬 Movies",
                    items: viewModel.movies
                ) { item in
                    Task { await viewModel.onMovieAppear(item) }
                } onItemTap: { item in
//                    onMovieSelected(Int32(item.id))
                    onNavigate(.movieDetail(id: Int32(item.id)))
                }

//                SectionView<PopularMovieEntity>(
//                    title: "🎬 Movies",
//                    items: viewModel.movies
//                ) { item in
//                    Task { await viewModel.onMovieAppear(item) }
//                    Button(action: {
//                        onMovieSelected(Int32(item.id))
//                    }) {
//                        Text(item.displayTitle)
//                    }
//                }
//
//                SectionView<PopularPeopleEntity>(
//                    title: "🧑‍🤝‍🧑 People",
//                    items: viewModel.people
//                ) { item in
//                    Task { await viewModel.onPeopleAppear(item) }
//                }
//
//                SectionView<PopularTVEntity>(
//                    title: "📺 TVs",
//                    items: viewModel.tvs
//                ) { item in
//                    Task { await viewModel.onTVAppear(item) }
//                }
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
