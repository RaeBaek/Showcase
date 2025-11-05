//
//  DetailInput.swift
//  DetailDomain
//
//  Created by 백래훈 on 10/31/25.
//

import Foundation

public struct DetailInput {
    public let id: Int32
    public let language: String
    public let page: Int32 = 1

    public init(id: Int32, language: String) {
        self.id = id
        self.language = language
    }
}
