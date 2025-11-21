//
//  ResponseParams.swift
//  Model
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

public struct ResponseParams {
    public let id: Int32
    public let language: String
    public let page: Int32

    public init(id: Int32, language: String, page: Int32 = 1) {
        self.id = id
        self.language = language
        self.page = page
    }
}
