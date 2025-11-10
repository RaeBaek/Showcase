//
//  Route.swift
//  NavigationInterface
//
//  Created by 백래훈 on 11/06/25.
//

import Foundation

// Core/NavigationInterface/Route.swift
public enum Route: Hashable {
    case movieDetail(id: Int32)
    case personDetail(id: Int32)
    case tvDetail(id: Int32)
}

public protocol Navigator {
    func push(_ route: Route)
    func pop()
}
