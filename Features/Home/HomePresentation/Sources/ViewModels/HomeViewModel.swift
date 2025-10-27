//
//  HomeViewModel.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation
import HomeDomain

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published private(set) var movies: PopularPage<PopularMovieEntity> = .empty
    @Published private(set) var people: PopularPage<PopularPeopleEntity> = .empty
    @Published private(set) var tvs: PopularPage<PopularTVEntity> = .empty
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: HomeUseCase

    private var isLoadingNextMovies = false
    private var isLoadingNextPeople = false
    private var isLoadingNextTVs = false

    private var lastRequestMoviesPage: Int = 0
    private var lastRequestPeoplePage: Int = 0
    private var lastRequestTVsPage: Int = 0

    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }

    func firstLoad() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let homeFeedInput = HomeFeedInput(page: 1, language: "ko-KR")
        do {
            async let movies = self.useCase.moviePopularList(homeFeedInput)
            async let people = self.useCase.peoplePopularList(homeFeedInput)
            async let tvs = self.useCase.tvPopularList(homeFeedInput)

            self.movies = try await movies
            self.people = try await people
            self.tvs = try await tvs
        } catch {
            errorMessage = "데이터를 불러오지 못했어요. 잠시 후 다시 시도해주세요."
        }
    }

    func loadNextMoviesIfNeeded(appearing item: PopularMovieEntity) async {
        guard !isLoadingNextMovies, movies.hasNext else { return }
        guard let idx = movies.items.firstIndex(where: { $0.id == item.id }) else { return }
        let threshold = max(0, movies.items.count - 5)
        guard idx >= threshold else { return }

        let next = movies.page + 1
        guard next != lastRequestMoviesPage else { return }
        lastRequestMoviesPage = next
        isLoadingNextMovies = true
        defer { isLoadingNextMovies = false }

        do {
            let page = try await useCase.moviePopularList(.init(page: next, language: "ko-KR"))
            let merged = movies.items + page.items
            movies = .init(
                items: merged,
                page: page.page,
                totalPages: page.totalPages,
                totalResults: page.totalResults
            )
        } catch {
            lastRequestMoviesPage = movies.page
        }
    }

    func loadNextPeopleIfNeeded(appearing item: PopularPeopleEntity) async {
        guard !isLoadingNextPeople, people.hasNext else { return }
        guard let idx = people.items.firstIndex(where: { $0.id == item.id }) else { return }
        let threshold = max(0, people.items.count - 5)
        guard idx >= threshold else { return }

        let next = people.page + 1
        guard next != lastRequestPeoplePage else { return }
        lastRequestPeoplePage = next
        isLoadingNextPeople = true
        defer { isLoadingNextPeople = false }

        do {
            let page = try await useCase.peoplePopularList(.init(page: next, language: "ko-KR"))
            let merged = people.items + page.items
            people = .init(
                items: merged,
                page: page.page,
                totalPages: page.totalPages,
                totalResults: page.totalResults
            )
        } catch {
            lastRequestPeoplePage = people.page
        }
    }

    func loadNextTVsIfNeeded(appearing item: PopularTVEntity) async {
        guard !isLoadingNextTVs, tvs.hasNext else { return }
        guard let idx = tvs.items.firstIndex(where: { $0.id == item.id }) else { return }
        let threshold = max(0, tvs.items.count - 5)
        guard idx >= threshold else { return }

        let next = tvs.page + 1
        guard next != lastRequestTVsPage else { return }
        lastRequestTVsPage = next
        isLoadingNextTVs = true
        defer { isLoadingNextTVs = false }

        do {
            let page = try await useCase.tvPopularList(.init(page: next, language: "ko-KR"))
            let merged = tvs.items + page.items
            tvs = .init(
                items: merged,
                page: page.page,
                totalPages: page.totalPages,
                totalResults: page.totalResults
            )
        } catch {
            lastRequestTVsPage = tvs.page
        }
    }
}
