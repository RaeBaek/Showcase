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
    @Published var detail: MovieDetailEntity?
    @Published var credits: [CreditPersonEntity] = []
    @Published var videos: [VideoItemEntity] = []
    @Published var similar: [SimilarMovieEntity] = []
    @Published var showFullOverview = false

    private let id: Int
    private let useCase: MovieDetailUseCase

    public init(id: Int, useCase: MovieDetailUseCase) {
        self.id = id
        self.useCase = useCase
    }

    func load() {
        Task {
            state = .loading
            do {
                async let fetchDetail = useCase.fetchDetail(id: id)
                async let fetchCredits = useCase.fetchCredits(id: id)
                async let fetchVideos = useCase.fetchVideos(id: id)
                async let fetchSimilar = useCase.fetchSimilar(id: id)

                let (detail, credits, videos, similar) = try await (fetchDetail, fetchCredits, fetchVideos, fetchSimilar)

                self.detail = detail
                self.credits = credits
                self.videos = videos
                self.similar = similar
                state = .loaded
            } catch {
                state = .failed(error.localizedDescription)
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
