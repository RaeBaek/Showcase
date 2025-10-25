//
//  HomeViewModel.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation
import HomeDomain

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var movies: [PopularMovieEntity] = []
    @Published var peoples: [PopularPeopleEntity] = []
    @Published var tvs: [PopularTVEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: HomeUseCase

    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let movies = try await self.useCase.moviePopularList()
            async let peoples = try await self.useCase.peoplePopularList()
            async let tvs = try await self.useCase.tvPopularList()

            self.movies = try await movies
            self.peoples = try await peoples
            self.tvs = try await tvs
        } catch {
            errorMessage = "데이터를 불러오지 못했어요. 잠시 후 다시 시도해주세요."
        }
    }
}
