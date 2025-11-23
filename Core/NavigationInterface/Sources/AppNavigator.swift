//
//  AppNavigator.swift
//  App
//
//  Created by 백래훈 on 11/6/25.
//

import SwiftUI

public final class AppNavigator: ObservableObject, Navigator {

    @Published public var path = NavigationPath()

    public init() { }

    public func push(_ route: Route) {
        path.append(route)
    }
    
    public func pop() {
        path.removeLast()
    }
}
