//
//  TVsPagingUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/28/25.
//

import Foundation

public final class TVsPagingUseCase: BasePagingUseCase<PopularTVEntity> {

    public init(repository: HomeRepository) {
        super.init(fetch: { next in
            try await repository.tvPopularList(.init(page: next, language: "ko-KR"))
        })
    }

    public func loadFirstTvs() async throws {
        try await loadFirst()
    }

    public func loadMoreTvsIfNeeded(currentItem: PopularTVEntity) async {
        await loadMoreIfNeeded(currentItem: currentItem, threshold: 5)
    }
}
