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
    @State private var loadingFailed = false
    @State private var connectionAttempt = 0

    init(request: Request) {
        self.request = request
    }

    var body: some View {
        Group {
            if let runtime {
                PreviewController(runtime: runtime, request: request)
            } else if loadingFailed {
                #if DEBUG
                VStack(spacing: 12) {
                    Text("Metro에 연결할 수 없어요. 로컬 네트워크 권한과 서버 주소를 확인해 주세요.")
                    Button("다시 시도") {
                        loadingFailed = false
                        connectionAttempt += 1
                    }
                }
                .padding()
                #else
                Text("React Native 화면을 불러올 수 없어요.")
                    .padding()
                #endif
            } else {
                ProgressView()
            }
        }
        .task(id: connectionAttempt) {
            await prepareRuntime()
        }
    }

    @MainActor
    private func prepareRuntime() async {
        guard runtime == nil else { return }
        if request.mode == .shared, let shared = Runtime.shared {
            runtime = shared
            return
        }

        #if DEBUG
        guard await waitForMetro() else {
            if !Task.isCancelled { loadingFailed = true }
            return
        }
        let bundleURLProvider: () -> URL? = {
            RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        }
        #else
        guard let bundleURL = Bundle.main.url(forResource: "main", withExtension: "jsbundle") else {
            loadingFailed = true
            return
        }
        let bundleURLProvider: () -> URL? = { bundleURL }
        #endif

        guard !Task.isCancelled else { return }
        let newRuntime = Runtime(bundleURLProvider: bundleURLProvider)
        if request.mode == .shared {
            Runtime.shared = newRuntime
        }
        runtime = newRuntime
    }

    #if DEBUG
    @MainActor
    private func waitForMetro() async -> Bool {
        let provider = RCTBundleURLProvider.sharedSettings()
        let bundledHost = Bundle.main.url(forResource: "ip", withExtension: "txt")
            .flatMap { try? String(contentsOf: $0, encoding: .utf8) }?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let host = bundledHost.flatMap { $0.isEmpty ? nil : $0 } ?? "localhost"
        provider.jsLocation = host
        guard var endpoint = URLComponents(string: "\(provider.packagerScheme)://\(host)"),
              endpoint.host != nil else { return false }
        endpoint.port = endpoint.port ?? 8081
        endpoint.path = "/status"
        guard let statusURL = endpoint.url else { return false }

        let statusRequest = URLRequest(url: statusURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 3)
        // The first request can fail while the local network permission alert is open.
        // Wait for a successful connection before creating either fresh or shared runtimes.
        for attempt in 0..<10 {
            guard !Task.isCancelled else { return false }
            if let (data, response) = try? await URLSession.shared.data(for: statusRequest),
               (response as? HTTPURLResponse)?.statusCode == 200,
               String(decoding: data, as: UTF8.self) == "packager-status:running" {
                return !Task.isCancelled
            }
            if attempt < 9 {
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    return false
                }
            }
        }
        return false
    }
    #endif

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
                    "originalTitle": movie.originalTitle as Any? ?? NSNull(),
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
