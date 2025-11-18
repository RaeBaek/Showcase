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
    private let usecase: PeopleDetailUseCase

    public init(id: Int32, usecase: PeopleDetailUseCase) {
        self.id = id
        self.usecase = usecase
    }

    public func load() {
        Task {
            self.peopleDetailState.state = .loading
            do {
                async let fetchDetail = self.usecase.fetchDetail(id: id)
                async let fetchCredits = self.usecase.fetchCredits(id: id)

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
