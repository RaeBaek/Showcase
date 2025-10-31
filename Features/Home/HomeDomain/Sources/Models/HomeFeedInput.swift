//
//  HomeFeedInput.swift
//  HomeDomain
//
//  Created by 백래훈 on 10/27/25.
//

import Foundation

public struct HomeFeedInput {
    public let page: Int
    public let language: String

    public init(page: Int, language: String) {
        self.page = page
        self.language = language
    }
}
