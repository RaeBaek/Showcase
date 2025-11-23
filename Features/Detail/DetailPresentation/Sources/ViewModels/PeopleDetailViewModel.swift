//
//  PersonDetailViewModel.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/6/25.
//

import Foundation
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

    public func load() {
        Task {
            self.peopleDetailState.state = .loading
            do {
                let input = DetailInput(id: id, language: language)
                async let fetchDetail = self.usecase.fetchDetail(input)
                async let fetchCredits = self.usecase.fetchCredits(input)

                let (detail, credits) = try await (fetchDetail, fetchCredits)

                self.peopleDetailState.detail = detail
                self.peopleDetailState.knownFors = credits

                self.peopleDetailState.state = .loaded
                print("PersonDetailViewModel State changed to:", self.peopleDetailState.state)
            } catch {
                self.peopleDetailState.state = .failed("PersonDetailViewModel: \(error.localizedDescription)")
            }
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
