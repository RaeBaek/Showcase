//
//  MockRepository.swift
//  HomeDomainTests
//
//  Created by 백래훈 on 10/29/25.
//

import Foundation
@testable import HomeDomain

/// HomeRepository를 채택받는 MockRepository
final class MockRepository: HomeRepository {
    enum Call: Equatable {
        case movie(Int, String)
        case people(Int, String)
        case tv(Int, String)
    }

    private(set) var calls: [Call] = []

    var moviePages: [Int: PopularPage<PopularMovieEntity>] = [:]
    var peoplePages: [Int: PopularPage<PopularPeopleEntity>] = [:]
    var tvPages: [Int: PopularPage<PopularTVEntity>] = [:]

    var movieError: Error?
    var peopleError: Error?
    var tvError: Error?

    func moviePopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularMovieEntity> {
        if let e = movieError { throw e }
        calls.append(.movie(input.page, input.language))
        guard let page = moviePages[input.page] else { throw URLError(.badServerResponse) }
        return page
    }

    func peoplePopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularPeopleEntity> {
        if let e = peopleError { throw e }
        calls.append(.people(input.page, input.language))
        guard let page = peoplePages[input.page] else { throw URLError(.badServerResponse) }
        return page
    }

    func tvPopularList(_ input: HomeFeedInput) async throws -> PopularPage<PopularTVEntity> {
        if let e = tvError { throw e }
        calls.append(.tv(input.page, input.language))
        guard let page = tvPages[input.page] else { throw URLError(.badServerResponse) }
        return page
    }
}

enum Stub: Error {
    case boom
}
