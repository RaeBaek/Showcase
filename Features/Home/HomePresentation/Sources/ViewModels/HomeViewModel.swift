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
        } catch let error as HomeDomainError {
            self.errorMessage = mapDomainErrorToMessage(error)
        } catch {
            self.errorMessage = "알 수 없는 오류가 발생했습니다."
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

    private func mapDomainErrorToMessage(_ error: HomeDomainError) -> String {
        switch error {
        case .network:
            return "인터넷 연결이 불안정합니다. 네트워크 상태를 확인해주세요."

        case .timeout:
            return "응답이 지연되고 있습니다. 잠시 후 다시 시도해주세요."

        case .unauthorized:
            return "접근 권한이 없습니다."

        case .forbidden:
            return "요청이 거부되었어요."

        case .notFound:
            return "요청한 데이터를 찾을 수 없습니다."

        case .tooManyRequests:
            return "요청이 너무 많습니다. 잠시 후 다시 시도해주세요."

        case .serverError:
            return "서버에 문제가 발생했습니다. 잠시 뒤 다시 시도해주세요."

        case .decoding:
            return "데이터 처리 중 오류가 발생했어요."

        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}
