//
//  HLSStream.swift
//  StreamingDomain
//
//  Created by 백래훈 on 10/24/25.
//

import Foundation

public struct HLSStream: Identifiable {
    public let id: String
    public let title: String
    public let description: String?
    public let url: URL

    public init(id: String, title: String, description: String?, url: URL) {
        self.id = id
        self.title = title
        self.description = description
        self.url = url
    }
}

public protocol FetchHLSStreamUseCase {
    func execute() -> [HLSStream]
}
