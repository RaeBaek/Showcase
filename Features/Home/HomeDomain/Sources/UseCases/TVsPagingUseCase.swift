//
//  TVsPagingUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/28/25.
//

import Foundation

public final class TVsPagingUseCase: BasePagingUseCase<PopularTVEntity> {

    private let language: String

    public init(repository: HomeRepository, language: String) {
        self.language = language
        super.init(fetch: { input in
            try await repository.tvPopularList(input)
        })
    }

    public func loadFirstTvs() async throws {
        try await loadFirst()
    }

    public func loadMoreTvsIfNeeded(currentItem: PopularTVEntity) async {
        await loadMoreIfNeeded(currentItem: currentItem, threshold: 5)
    }

    public override func makeParams(page: Int) -> HomeFeedInput {
        return HomeFeedInput(page: page, language: language)
    }
}
