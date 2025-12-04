//
//  PersonDetailViewModel.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/6/25.
//

import Foundation

import PresentationInterface

import DetailDomain

@MainActor
public final class PeopleDetailViewModel: ObservableObject {
    @Published private(set) var peopleDetailState = PeopleDetailState()

    private let id: Int32
    private let language: String
    private let usecase: PeopleDetailUseCase

    public init(
        id: Int32,
        language: String,
        usecase: PeopleDetailUseCase
    ) {
        self.id = id
        self.language = language
        self.usecase = usecase
    }

    public func load() async {
        self.peopleDetailState.state = .loading

        do {
            let input = DetailInput(id: id, language: language)

            async let detailTask = self.usecase.fetchDetail(input)
            async let creditsTask = self.usecase.fetchCredits(input)

            let (detail, credits) = try await (detailTask, creditsTask)

            self.peopleDetailState.detail = detail
            self.peopleDetailState.knownFors = credits

            self.peopleDetailState.state = .loaded
        } catch let domainError as DetailDomainError {
            self.peopleDetailState.state = .failed(DomainErrorMessageMapper.message(for: domainError))
        } catch {
            self.peopleDetailState.state = .failed("알 수 없는 오류가 발생했어요.")
        }
    }

    public func toggleOverviewExpanded() {
        peopleDetailState.showFullBio.toggle()
    }
}

struct PeopleDetailState {
    var state: LoadState = .idle
    var detail: PersonDetailEntity?
    var knownFors: [KnownForItem]?
    var showFullBio = false
}
