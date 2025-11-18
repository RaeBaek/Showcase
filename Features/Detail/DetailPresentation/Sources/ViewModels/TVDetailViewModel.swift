//
//  TVDetailViewModel.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation
import DetailDomain

@MainActor
public final class TVDetailViewModel: ObservableObject {
    @Published private(set) var tvDetailState = TVState()

    private let id: Int32
    private let useCase: TVDetailUseCase

    public init(id: Int32, useCase: TVDetailUseCase) {
        self.id = id
        self.useCase = useCase
    }

    public func load() {
        Task {
            self.tvDetailState.state = .loading
            do {
                async let fetchDetail = self.useCase.fetchDetail(id: id)
                async let fetchCredits = self.useCase.fetchCredits(id: id)
                async let fetchVideos = self.useCase.fetchVideos(id: id)
                async let fetchSimilars = self.useCase.fetchSimilars(id: id)

                let (detail, credits, videos, similars) = try await (fetchDetail, fetchCredits, fetchVideos, fetchSimilars)
                let adapter = TVHeaderAdapter(info: detail)

                self.tvDetailState.adater = adapter
                self.tvDetailState.credits = credits
                self.tvDetailState.videos = videos
                self.tvDetailState.similars = similars

                self.tvDetailState.state = .loaded
                print("TVDetailViewModel State changed to:", self.tvDetailState.state)
            } catch {
                self.tvDetailState.state = .failed("TVDetailViewModel: \(error.localizedDescription)")
            }
        }
    }

    public func toggleOverviewExpanded() {
        tvDetailState.showFullOverview.toggle()
    }
}

struct TVState {
    var state: LoadState = .idle
    var adater: TVHeaderAdapter?
    var credits: [CreditInfoEntity] = []
    var videos: [VideoItemEntity] = []
    var similars: [SimilarItemEntity] = []
    var showFullOverview = false
}
