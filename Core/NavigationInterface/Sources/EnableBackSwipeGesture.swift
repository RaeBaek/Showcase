//
//  EnableBackSwipeGesture.swift
//  NavigationInterface
//
//  Created by 백래훈 on 11/20/25.
//

import SwiftUI

public struct EnableBackSwipeGesture: UIViewControllerRepresentable {

    public init() { }

    public func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            controller.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
