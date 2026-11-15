#if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider
import SwiftUI
import UIKit

struct SimilarMoviesReactNativePreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        HostViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private final class HostViewController: UIViewController {
        private let factoryDelegate = FactoryDelegate()
        private lazy var factory = RCTReactNativeFactory(delegate: factoryDelegate)

        override func loadView() {
            factoryDelegate.dependencyProvider = RCTAppDependencyProvider()
            view = factory.rootViewFactory.view(withModuleName: "SimilarMoviesPreview")
        }
    }

    private final class FactoryDelegate: RCTDefaultReactNativeFactoryDelegate {
        override func sourceURL(for bridge: RCTBridge) -> URL? {
            bundleURL()
        }

        override func bundleURL() -> URL? {
            RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        }
    }
}
#endif
