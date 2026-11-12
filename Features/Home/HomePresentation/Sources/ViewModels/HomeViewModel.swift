//
//  HomeViewModel.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation
import Combine

import PresentationInterface

import HomeDomain

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published private(set) var movies: [PopularMovieEntity] = []
    @Published private(set) var people: [PopularPeopleEntity] = []
    @Published private(set) var tvs: [PopularTVEntity] = []
    @Published var errorMessage: String?

    private let moviesUsecase: any PagingUseCase<PopularMovieEntity>
    private let peopleUsecase: any PagingUseCase<PopularPeopleEntity>
    private let tvsUsecase: any PagingUseCase<PopularTVEntity>

    private var didLoadMovies = false
    private var didLoadPeople = false
    private var didLoadTVs = false
    private var isLoadingInitialSections = false
    private var cancellables = Set<AnyCancellable>()

    public init(
        moviesUsecase: any PagingUseCase<PopularMovieEntity>,
        peopleUsecase: any PagingUseCase<PopularPeopleEntity>,
        tvsUsecase: any PagingUseCase<PopularTVEntity>
    ) {
        self.moviesUsecase = moviesUsecase
        self.peopleUsecase = peopleUsecase
        self.tvsUsecase = tvsUsecase

        self.moviesUsecase.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.movies = $0 }
            .store(in: &cancellables)

        self.peopleUsecase.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.people = $0 }
            .store(in: &cancellables)

        self.tvsUsecase.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.tvs = $0 }
            .store(in: &cancellables)
    }

    func firstLoad() async {
        guard !isLoadingInitialSections else { return }
        isLoadingInitialSections = true
        defer { isLoadingInitialSections = false }

        var failureMessage: String?
        if !didLoadMovies {
            didLoadMovies = await loadInitialSection(errorMessage: &failureMessage) {
                try await moviesUsecase.loadFirst()
            }
        }
        if !didLoadPeople {
            didLoadPeople = await loadInitialSection(errorMessage: &failureMessage) {
                try await peopleUsecase.loadFirst()
            }
        }
        if !didLoadTVs {
            didLoadTVs = await loadInitialSection(errorMessage: &failureMessage) {
                try await tvsUsecase.loadFirst()
            }
        }
        if !Task.isCancelled {
            errorMessage = failureMessage
        }
    }

    private func loadInitialSection(
        errorMessage: inout String?,
        load: () async throws -> Void
    ) async -> Bool {
        do {
            try Task.checkCancellation()
            try await load()
            return true
        } catch {
            guard !Task.isCancelled, errorMessage == nil else { return false }
            if let domainError = error as? HomeDomainError {
                errorMessage = DomainErrorMessageMapper.message(for: domainError)
            } else {
                errorMessage = "알 수 없는 오류가 발생했습니다."
            }
            return false
        }
    }

    func onMovieAppear(_ item: PopularMovieEntity) async {
        await moviesUsecase.loadMoreIfNeeded(currentItem: item, threshold: 5)
    }

    func onPeopleAppear(_ item: PopularPeopleEntity) async {
        await peopleUsecase.loadMoreIfNeeded(currentItem: item, threshold: 5)
    }

    func onTVAppear(_ item: PopularTVEntity) async {
        await tvsUsecase.loadMoreIfNeeded(currentItem: item, threshold: 5)
    }
}
