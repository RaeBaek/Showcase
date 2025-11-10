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
    @Published var state: LoadState = .idle
    @Published var adapter: MovieHeaderAdapter?
    @Published var credits: [CreditInfoEntity] = []
    @Published var videos: [VideoItemEntity] = []
    @Published var similars: [SimilarItemEntity] = []
    @Published var showFullOverview = false

    private let id: Int32
    private let useCase: MovieDetailUseCase

    public init(id: Int32, useCase: MovieDetailUseCase) {
        self.id = id
        self.useCase = useCase
    }

    func load() {
        Task {
            state = .loading
            do {
                async let fetchDetail = self.useCase.fetchDetail(id: id)
                async let fetchCredits = useCase.fetchCredits(id: id)
                async let fetchVideos = self.useCase.fetchVideos(id: id)
                async let fetchSimilars = self.useCase.fetchSimilar(id: id)

                let (detail, credits, videos, similars) = try await (fetchDetail, fetchCredits, fetchVideos, fetchSimilars)
                let adapter = MovieHeaderAdapter(info: detail)

                self.adapter = adapter
                self.credits = credits
                self.videos = videos
                self.similars = similars

                state = .loaded
                print("MovieDetailViewModel State changed to:", state)
            } catch {
                state = .failed("MovieDetailViewModel: \(error.localizedDescription)")
            }
        }
    }
}

enum LoadState {
    case idle
    case loading
    case loaded
    case failed(String)
}
