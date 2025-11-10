//
//  TVDetailViewModel.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/10/25.
//

import Foundation
import DetailDomain

final class TVDetailViewModel: ObservableObject {
    @Published var state: LoadState = .idle
    @Published var tvState = TVState()

    struct TVState {
        var detail: TVDetailEntity?
        var cast: [MovieCastEntity] = []
        var similarShows: [TVSummaryEntity] = []
        var isLoading = false
        var error: String?
    }

    private let id: Int32

    init(id: Int32) {
        self.id = id
    }

    public func load() {
        Task {
            do {

            } catch {
                state = .failed("TVDetailViewModel: \(error.localizedDescription)")
            }
        }
    }
}
