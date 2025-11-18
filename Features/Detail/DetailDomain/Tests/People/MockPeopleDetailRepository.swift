//
//  MockPeopleDetailRepository.swift
//  DetailDomainTests
//
//  Created by 백래훈 on 11/18/25.
//

import Foundation
@testable import DetailDomain

final class MockPeopleDetailRepository: PeopleDetailRepository {

    // MARK: - Inputs 캡쳐
    private(set) var detailInputs: [DetailInput] = []
    private(set) var creditsInputs: [DetailInput] = []

    // MARK: - Stubbed 엔티티
    var stubPerson: PersonEntity!
    var stubPersonCombineCredits: PersonCombineCreditsEntity!

    // MARK: - Stubbed 에러
    var error: Error?

    func fetchDetail(_ input: DetailInput) async throws -> PersonEntity {
        if let error { throw error }
        detailInputs.append(input)
        return stubPerson
    }
    
    func fetchCredits(_ input: DetailInput) async throws -> PersonCombineCreditsEntity {
        if let error { throw error }
        creditsInputs.append(input)
        return stubPersonCombineCredits
    }
}
