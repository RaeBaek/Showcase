//
//  MovieDetailViewModel.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import Foundation
import DetailDomain

@MainActor
public final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var movieDetailState = MovieDetailState()

    private let id: Int32
    private let useCase: MovieDetailUseCase

    public init(id: Int32, useCase: MovieDetailUseCase) {
        self.id = id
        self.useCase = useCase
    }

    public func load() {
        Task {
            self.movieDetailState.state = .loading
            do {
                async let fetchDetail = self.useCase.fetchDetail(id: id)
                async let fetchCredits = useCase.fetchCredits(id: id)
                async let fetchVideos = self.useCase.fetchVideos(id: id)
                async let fetchSimilars = self.useCase.fetchSimilar(id: id)

                let (detail, credits, videos, similars) = try await (fetchDetail, fetchCredits, fetchVideos, fetchSimilars)
                let adapter = MovieHeaderAdapter(info: detail)

                self.movieDetailState.adapter = adapter
                self.movieDetailState.credits = credits
                self.movieDetailState.videos = videos
                self.movieDetailState.similars = similars

                self.movieDetailState.state = .loaded
                print("MovieDetailViewModel State changed to:", self.movieDetailState.state)
            } catch {
                self.movieDetailState.state = .failed("MovieDetailViewModel: \(error.localizedDescription)")
            }
        }
    }

    public func toggleOverviewExpanded() {
        movieDetailState.showFullOverview.toggle()
    }
}

enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

struct MovieDetailState {
    var state: LoadState = .idle
    var adapter: MovieHeaderAdapter?
    var credits: [CreditInfoEntity] = []
    var videos: [VideoItemEntity] = []
    var similars: [SimilarItemEntity] = []
    var showFullOverview: Bool = false
}
