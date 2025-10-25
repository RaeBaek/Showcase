//
//  HomeUseCase.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

public protocol HomeUseCase {
    // MARK: 수정 리스트 3종
    func movieModifyList() async throws -> [ModifyEntity]
    func peopleModifyList() async throws -> [ModifyEntity]
    func tvModifyList() async throws -> [ModifyEntity]

    // MARK: 인기 리스트 3종
    func moviePopularList() async throws -> [PopularMovieEntity]
    func peoplePopularList() async throws -> [PopularPeopleEntity]
    func tvPopularList() async throws -> [PopularTVEntity]
}
