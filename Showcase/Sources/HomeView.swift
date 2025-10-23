//
//  HomeView.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SectionView(title: "🎬 Movies", items: viewModel.movies)
                    SectionView(title: "🧑‍🤝‍🧑 Peoples", items: viewModel.peoples)
                    SectionView(title: "📺 TVs", items: viewModel.tvs)
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

private struct SectionView: View {
    let title: String
    let items: [PopularEntity]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.bold())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { entity in
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 12)
                                .overlay {
                                    if let path = entity.posterPath,
                                       let url = URL(string: "https://image.tmdb.org/t/p/w500" + path) {
                                        AsyncImage(url: url) { img in
                                            if let image = img.image {
                                                image.resizable().scaledToFill()
                                            } else if img.error != nil {
                                                Color.gray.opacity(0.2)
                                            } else {
                                                ZStack {
                                                    Color.gray.opacity(0.15)
                                                    ProgressView()
                                                }
                                            }
                                        }
//                                        placeholder: {
//                                            ZStack {
//                                                Color.gray.opacity(0.15)
//                                                ProgressView()
//                                            }
//                                        }
                                    }
                                }
                                .frame(width: 120, height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(entity.title ?? "")
                                .lineLimit(1)
                                .font(.footnote)
                                .frame(width: 120, alignment: .leading)
                        }
                    }
                }
                .padding(.trailing, 16)
            }
        }
    }
}

#Preview {
    HomeView()
}
