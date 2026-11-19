//
//  SimilarMoviesReactNativePreview.swift
//  Showcase
//
//  Created by 백래훈 on 11/15/26.
//

import DetailDomain
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider
import SwiftUI
import UIKit

struct SimilarMoviesReactNativePreview: View {
    enum Mode {
        case fresh
        case shared
    }

    struct Request: Identifiable {
        let id = UUID()
        let mode: Mode
        let movies: [SimilarItemEntity]
    }

    let request: Request
    @State private var runtime: Runtime?
    @State private var bundleMissing = false

    init(request: Request) {
        self.request = request
    }

    var body: some View {
        Group {
            if let runtime {
                PreviewController(runtime: runtime, request: request)
            } else if bundleMissing {
                Text("React Native 화면을 불러올 수 없어요.")
                    .padding()
            } else {
                ProgressView()
            }
        }
        .task {
            prepareRuntime()
        }
    }

    @MainActor
    private func prepareRuntime() {
        guard runtime == nil else { return }
        if request.mode == .shared, let shared = Runtime.shared {
            runtime = shared
            return
        }

        #if DEBUG
        let bundleURLProvider: () -> URL? = {
            RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        }
        #else
        guard let bundleURL = Bundle.main.url(forResource: "main", withExtension: "jsbundle") else {
            bundleMissing = true
            return
        }
        let bundleURLProvider: () -> URL? = { bundleURL }
        #endif

        let newRuntime = Runtime(bundleURLProvider: bundleURLProvider)
        if request.mode == .shared {
            Runtime.shared = newRuntime
        }
        runtime = newRuntime
    }

    private struct PreviewController: UIViewControllerRepresentable {
        let runtime: Runtime
        let request: Request

        func makeUIViewController(context: Context) -> UIViewController {
            HostViewController(runtime: runtime, request: request)
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }

    @MainActor
    private final class Runtime {
        static var shared: Runtime?

        private let factoryDelegate: FactoryDelegate
        lazy var factory = RCTReactNativeFactory(delegate: factoryDelegate)

        init(bundleURLProvider: @escaping () -> URL?) {
            factoryDelegate = FactoryDelegate(bundleURLProvider: bundleURLProvider)
            factoryDelegate.dependencyProvider = RCTAppDependencyProvider()
        }
    }

    private final class HostViewController: UIViewController {
        private let runtime: Runtime
        private let request: Request

        init(runtime: Runtime, request: Request) {
            self.runtime = runtime
            self.request = request
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func loadView() {
            let movieProperties: [[String: Any]] = request.movies.map { movie in
                [
                    "id": movie.id,
                    "title": movie.title as Any? ?? NSNull(),
                    "posterURL": movie.posterURL?.absoluteString as Any? ?? NSNull()
                ]
            }
            view = runtime.factory.rootViewFactory.view(
                withModuleName: "SimilarMoviesPreview",
                initialProperties: ["movies": movieProperties, "requestID": request.id.uuidString]
            )
        }
    }

    private final class FactoryDelegate: RCTDefaultReactNativeFactoryDelegate {
        private let bundleURLProvider: () -> URL?

        init(bundleURLProvider: @escaping () -> URL?) {
            self.bundleURLProvider = bundleURLProvider
            super.init()
        }
        
        override func sourceURL(for bridge: RCTBridge) -> URL? {
            bundleURL()
        }

        override func bundleURL() -> URL? {
            bundleURLProvider()
        }
    }
}
