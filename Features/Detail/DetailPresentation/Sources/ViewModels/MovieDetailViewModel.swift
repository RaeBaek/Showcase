//
//  MovieDetailViewModel.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import Foundation

import PresentationInterface

import DetailDomain

@MainActor
public final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var movieDetailState = MovieDetailState()

    private let id: Int32
    private let language: String
    private let useCase: MovieDetailUseCase

    public init(
        id: Int32,
        language: String,
        useCase: MovieDetailUseCase
    ) {
        self.id = id
        self.language = language
        self.useCase = useCase
    }

    public func load() async {
        self.movieDetailState.state = .loading

        do {
            let input = DetailInput(id: id, language: language)

            async let detailTask = self.useCase.fetchDetail(input)
            async let creditsTask = self.useCase.fetchCredits(input)
            async let videosTask = self.useCase.fetchVideos(input)
            async let similarTask = self.useCase.fetchSimilar(input)

            let (detail, credits, videos, similars) = try await (detailTask, creditsTask, videosTask, similarTask)

            let adapter = MovieHeaderAdapter(info: detail)

            self.movieDetailState.adapter = adapter
            self.movieDetailState.credits = credits
            self.movieDetailState.videos = videos
            self.movieDetailState.similars = similars

            self.movieDetailState.state = .loaded
        } catch let domainError as DetailDomainError {
            self.movieDetailState.state = .failed(DomainErrorMessageMapper.message(for: domainError))
        } catch {
            self.movieDetailState.state = .failed("알 수 없는 오류가 발생했어요.")
        }
    }

    public func toggleOverviewExpanded() {
        movieDetailState.showFullOverview.toggle()
    }
}

struct MovieDetailState {
    var state: LoadState = .idle
    var adapter: MovieHeaderAdapter?
    var credits: [CreditInfoEntity] = []
    var videos: [VideoItemEntity] = []
    var similars: [SimilarItemEntity] = []
    var showFullOverview: Bool = false
}
