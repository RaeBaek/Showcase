//
//  PeoplePagingUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/28/25.
//

import Foundation

public final class PeoplePagingUseCase: BasePagingUseCase<PopularPeopleEntity> {

    private let language: String

    public init(repository: HomeRepository, language: String) {
        self.language = language
        super.init(fetch: { params in
            try await repository.peoplePopularList(params)
        })
    }

    public func loadFirstPeople() async throws {
        try await loadFirst()
    }

    public func loadMorePeopleIfNeeded(currentItem: PopularPeopleEntity) async {
        await loadMoreIfNeeded(currentItem: currentItem, threshold: 5)
    }

    public override func makeParams(page: Int) -> HomeFeedInput {
        return HomeFeedInput(page: page, language: language)
    }
}
