//
//  DetailRepository.swift
//  DetailDomain
//
//  Created by 백래훈 on 10/31/25.
//

import Foundation

public protocol DetailRepository {
    func fetchDetail(_ input: DetailInput) async throws
}

public protocol MovieDetailRepository: DetailRepository {
    func fetchDetail(_ input: DetailInput) async throws
}

public protocol PeopleDetailRepository: DetailRepository {
    func fetchDetail(_ input: DetailInput) async throws
}

public protocol TVDetailRepository: DetailRepository {
    func fetchDetail(_ input: DetailInput) async throws
}
