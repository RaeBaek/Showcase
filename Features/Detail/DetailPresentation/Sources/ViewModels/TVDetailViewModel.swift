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
    private let language: String
    private let useCase: TVDetailUseCase

    public init(
        id: Int32,
        language: String,
        useCase: TVDetailUseCase
    ) {
        self.id = id
        self.language = language
        self.useCase = useCase
    }

    public func load() async {
        self.tvDetailState.state = .loading
        do {
            let input = DetailInput(id: id, language: language)
            async let fetchDetail = self.useCase.fetchDetail(input)
            async let fetchCredits = self.useCase.fetchCredits(input)
            async let fetchVideos = self.useCase.fetchVideos(input)
            async let fetchSimilars = self.useCase.fetchSimilars(input)

            let (detail, credits, videos, similars) = try await (fetchDetail, fetchCredits, fetchVideos, fetchSimilars)
            let adapter = TVHeaderAdapter(info: detail)

            self.tvDetailState.adater = adapter
            self.tvDetailState.credits = credits
            self.tvDetailState.videos = videos
            self.tvDetailState.similars = similars

            self.tvDetailState.state = .loaded
            print("TVDetailViewModel State changed to:", self.tvDetailState.state)
        } catch {
            let error = error as NSError
            self.tvDetailState.state = .failed("TVDetailViewModel: \(error.code)")
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
