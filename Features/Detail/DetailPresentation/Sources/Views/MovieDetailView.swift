//
//  MovieDetailView.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI
import AVKit
import DetailDomain

public struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    private let onNavigate: (Route) -> Void

    public init(
        viewModel: MovieDetailViewModel,
        onNavigate: @escaping (Route) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNavigate = onNavigate
    }

    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                LoadingSkeleton()
                    .onAppear { viewModel.load() }
            case .failed(let message):
                VStack(spacing: 12) {
                    Text("로딩 실패")
                        .font(.headline)
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("다시 시도") { viewModel.load() }
                }
                .padding(.top, 80)
            case .loaded:
                if let detail = viewModel.detail {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            HeaderBackdrop(detail: detail)
                            ActionBar()
                            OverviewSection(
                                text: detail.overview,
                                expanded: $viewModel.showFullOverview
                            )
                            if !viewModel.credits.isEmpty {
                                CreditSection(credits: viewModel.credits)
                            }
                            if !viewModel.videos.isEmpty {
                                VideoSection(videos: viewModel.videos)
                            }
                            if !viewModel.similar.isEmpty {
                                SimilarSection(list: viewModel.similar) { item in
                                    onNavigate(.movieDetail(id: Int32(item.id)))
                                }
                            }
                            Spacer(minLength: 40)
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                }
            }
        }
    }
}

// 예시 Stub
//struct StubMovieDetailUseCase: MovieDetailUseCase {
//    func fetchDetail(id: Int32) async throws -> MovieDetailInfoEntity {
//        .init(id: id,
//              title: "다 이루어질지니",
//              originalTitle: "A Thousand Years Wish",
//              overview: "천 년 만에 램프의 정령을 깨운 그녀...",
//              releaseDate: "2025-05-01",
//              voteAverage: 7.8,
//              genres: [
//                .init(id: 213, name: "판타지"),
//                .init(id: 123, name: "로맨스")
//              ],
//              runtime: 123,
//              backdropURL: URL(string:"https://image.tmdb.org/t/p/w780/xxx.jpg"),
//              posterURL: URL(string:"https://image.tmdb.org/t/p/w342/yyy.jpg"))
//    }
//
//    func fetchCredits(id: Int32) async throws -> [CreditPersonEntity] {
//        [.init(id: 1, name: "수지", role: "주연", profileURL: nil),
//         .init(id: 2, name: "김우빈", role: "주연", profileURL: nil)]
//    }
//
//    func fetchVideos(id: Int32) async throws -> [VideoItemEntity] {
//        [.init(id: "1", name: "메인 트레일러", site: "YouTube", key: "abcd1234", type: "Trailer")]
//    }
//
//    func fetchSimilar(id: Int32) async throws -> [SimilarMovieEntity] {
//        (1...10).map { .init(id: $0, title: "비슷한 영화 \($0)", posterURL: nil) }
//    }
//}

