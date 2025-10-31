//
//  Modify.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import Foundation

public struct ModifyEntity: Identifiable {
    public let id: Int?
    public let adult: Bool?

    public init(id: Int?, adult: Bool?) {
        self.id = id
        self.adult = adult
    }
}
