//
//  TVDetailViewModel.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation

import PresentationInterface

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

            async let detailTask = self.useCase.fetchDetail(input)
            async let creditsTask = self.useCase.fetchCredits(input)
            async let videosTask = self.useCase.fetchVideos(input)
            async let similarTask = self.useCase.fetchSimilars(input)

            let (detail, credits, videos, similars) = try await (detailTask, creditsTask, videosTask, similarTask)

            let adapter = TVHeaderAdapter(info: detail)

            self.tvDetailState.adater = adapter
            self.tvDetailState.credits = credits
            self.tvDetailState.videos = videos
            self.tvDetailState.similars = similars

            self.tvDetailState.state = .loaded
        } catch let domainError as DetailDomainError {
            self.tvDetailState.state = .failed(DomainErrorMessageMapper.message(for: domainError))
        } catch {
            self.tvDetailState.state = .failed("알 수 없는 오류가 발생했어요.")
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
