//
//  HomeViewModel.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation
import Combine
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
        do {
            try await self.moviesUsecase.loadFirst()
            try await self.peopleUsecase.loadFirst()
            try await self.tvsUsecase.loadFirst()
        } catch {
            errorMessage = "데이터를 불러오지 못했어요. 잠시 후 다시 시도해주세요."
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
