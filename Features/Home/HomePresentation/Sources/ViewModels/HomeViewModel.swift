//
//  HomeViewModel.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var movies: [PopularMovieEntity] = []
    @Published var peoples: [PopularPeopleEntity] = []
    @Published var tvs: [PopularTVEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let tmdbClient = TMDBClient.shared

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let movies = try await tmdbClient.moviePopularList()
            async let peoples = try await tmdbClient.peoplePopularList()
            async let tvs = try await tmdbClient.tvPopularList()

            self.movies = try await movies.results?.map { $0.toEntity } ?? []
            self.peoples = try await peoples.results?.map { $0.toEntity } ?? []
            self.tvs = try await tvs.results?.map { $0.toEntity } ?? []
        } catch {
            errorMessage = "데이터를 불러오지 못했어요. 잠시 후 다시 시도해주세요."
        }
    }
}
