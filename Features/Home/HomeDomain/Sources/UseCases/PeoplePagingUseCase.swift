//
//  PeoplePagingUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/28/25.
//

import Foundation

public final class PeoplePagingUseCase: BasePagingUseCase<PopularPeopleEntity> {

    public init(repository: HomeRepository) {
        super.init(fetch: { next in
            try await repository.peoplePopularList(.init(page: next, language: "ko-KR"))
        })
    }

    public func loadFirstPeople() async throws {
        try await loadFirst()
    }

    public func loadMorePeopleIfNeeded(currentItem: PopularPeopleEntity) async {
        await loadMoreIfNeeded(currentItem: currentItem, threshold: 5)
    }
}
