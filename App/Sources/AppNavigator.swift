//
//  AppNavigator.swift
//  App
//
//  Created by 백래훈 on 11/6/25.
//

import SwiftUI
import NavigationInterface

final class AppNavigator: ObservableObject, Navigator {
    
    @Published var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
}
