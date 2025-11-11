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
    @Published var state: LoadState = .idle
    @Published private(set) var detail: PersonDetailEntity?
    @Published private(set) var knownFors: [KnownForItem]?
    @Published var showFullBio = false

    private let id: Int32
    private let usecase: PeopleDetailUseCase

    public init(id: Int32, usecase: PeopleDetailUseCase) {
        self.id = id
        self.usecase = usecase
    }

    public func load() {
        Task {
            state = .loading
            do {
                async let fetchDetail = self.usecase.fetchDetail(id: id)
                async let fetchCredits = self.usecase.fetchCredits(id: id)

                let (detail, credits) = try await (fetchDetail, fetchCredits)

                self.detail = detail
                self.knownFors = credits

                state = .loaded
                print("PersonDetailViewModel State changed to:", state)
            } catch {
                state = .failed("PersonDetailViewModel: \(error.localizedDescription)")
            }
        }
    }
}
