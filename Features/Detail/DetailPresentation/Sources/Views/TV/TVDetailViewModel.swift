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
    @Published var state: LoadState = .idle
    @Published var tvState = TVState()

    struct TVState {
        var adater: TVHeaderAdapter?
        var credits: [CreditInfoEntity] = []
        var videos: [VideoItemEntity] = []
        var similars: [SimilarItemEntity] = []
        var showFullOverview = false
    }

    private let id: Int32
    private let useCase: TVDetailUseCase

    public init(id: Int32, useCase: TVDetailUseCase) {
        self.id = id
        self.useCase = useCase
    }

    public func load() {
        Task {
            state = .loading
            do {
                async let fetchDetail = self.useCase.fetchDetail(id: id)
                async let fetchCredits = self.useCase.fetchCredits(id: id)
                async let fetchVideos = self.useCase.fetchVideos(id: id)
                async let fetchSimilars = self.useCase.fetchSimilars(id: id)

                let (detail, credits, videos, similars) = try await (fetchDetail, fetchCredits, fetchVideos, fetchSimilars)
                let adapter = TVHeaderAdapter(info: detail)

                self.tvState.adater = adapter
                self.tvState.credits = credits
                self.tvState.videos = videos
                self.tvState.similars = similars

                state = .loaded
                print("TVDetailViewModel State changed to:", state)
            } catch {
                state = .failed("TVDetailViewModel: \(error.localizedDescription)")
            }
        }
    }
}
