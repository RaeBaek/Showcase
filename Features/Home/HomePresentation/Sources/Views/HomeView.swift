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
                    SectionView<PopularMovieEntity>(title: "🎬 Movies", items: viewModel.movies)
                    SectionView<PopularPeopleEntity>(title: "🧑‍🤝‍🧑 Peoples", items: viewModel.peoples)
                    SectionView<PopularTVEntity>(title: "📺 TVs", items: viewModel.tvs)
                }
                .padding(16)
            }
            .navigationTitle("Showcase")
        }
        .task {
            await viewModel.load()
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
