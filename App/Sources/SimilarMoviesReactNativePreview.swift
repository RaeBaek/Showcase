//
//  SimilarMoviesReactNativePreview.swift
//  Showcase
//
//  Created by 백래훈 on 11/15/26.
//

#if DEBUG && canImport(React) && canImport(React_RCTAppDelegate) && canImport(ReactAppDependencyProvider)
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
    @State private var connectionFailed = false
    @State private var connectionAttempt = 0

    init(request: Request) {
        self.request = request
    }

    var body: some View {
        Group {
            if let runtime {
                PreviewController(runtime: runtime, request: request)
            } else if connectionFailed {
                VStack(spacing: 12) {
                    Text("Metro에 연결할 수 없어요. 로컬 네트워크 권한과 Metro 주소를 확인해 주세요.")
                    Button("다시 시도") {
                        connectionFailed = false
                        connectionAttempt += 1
                    }
                }
                .padding()
            } else {
                ProgressView("Metro 연결 중…")
            }
        }
        .task(id: connectionAttempt) {
            await connectToMetro()
        }
    }

    @MainActor
    private func connectToMetro() async {
        if request.mode == .shared, let shared = Runtime.shared {
            runtime = shared
            return
        }

        let provider = RCTBundleURLProvider.sharedSettings()
        let bundledHost = Bundle.main.url(forResource: "ip", withExtension: "txt")
            .flatMap { try? String(contentsOf: $0, encoding: .utf8) }?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let host = [provider.jsLocation, bundledHost].compactMap { $0 }.first { !$0.isEmpty } ?? "localhost"
        let scheme = provider.packagerScheme
        guard var endpoint = URLComponents(string: "\(scheme)://\(host)"),
              endpoint.host != nil else {
            connectionFailed = true
            return
        }
        let port = endpoint.port ?? 8081
        let hostAndPort = endpoint.port == nil ? "\(host):\(port)" : host
        endpoint.port = port
        endpoint.path = "/status"
        guard let statusURL = endpoint.url else {
            connectionFailed = true
            return
        }

        let statusRequest = URLRequest(url: statusURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 3)
        // The first request can fail while the local network permission alert is open.
        for attempt in 0..<10 {
            guard !Task.isCancelled else { return }
            if let (data, response) = try? await URLSession.shared.data(for: statusRequest),
               (response as? HTTPURLResponse)?.statusCode == 200,
               String(decoding: data, as: UTF8.self) == "packager-status:running" {
                guard !Task.isCancelled else { return }
                let connectedRuntime = Runtime(packagerHost: hostAndPort, packagerScheme: scheme)
                if request.mode == .shared {
                    Runtime.shared = connectedRuntime
                }
                runtime = connectedRuntime
                return
            }
            if attempt < 9 {
                try? await Task.sleep(for: .seconds(1))
            }
        }
        if !Task.isCancelled {
            connectionFailed = true
        }
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

        init(packagerHost: String, packagerScheme: String) {
            factoryDelegate = FactoryDelegate(packagerHost: packagerHost, packagerScheme: packagerScheme)
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
        private let packagerHost: String
        private let packagerScheme: String

        init(packagerHost: String, packagerScheme: String) {
            self.packagerHost = packagerHost
            self.packagerScheme = packagerScheme
            super.init()
        }

        override func sourceURL(for bridge: RCTBridge) -> URL? {
            bundleURL()
        }

        override func bundleURL() -> URL? {
            RCTBundleURLProvider.sharedSettings().jsBundleURL(
                forBundleRoot: "index",
                packagerServerScheme: packagerScheme,
                packagerServerHost: packagerHost,
                packagerOptionsUpdater: { $0 }
            )
        }
    }
}
#endif
