//
//  HLSDemoViewModel.swift
//  StreamingPresentation
//
//  Created by 백래훈 on 11/13/25.
//

import SwiftUI
import AVKit
import StreamingDomain

public final class HLSDemoViewModel: ObservableObject {
    private let fetchStreamsUseCase: FetchHLSStreamUseCase

    @Published public private(set) var streams: [HLSStream] = []
    @Published public var selectedSteam: HLSStream?

    public init(fetchStreamsUseCase: FetchHLSStreamUseCase) {
        self.fetchStreamsUseCase = fetchStreamsUseCase
    }

    public func onAppear() {
        streams = fetchStreamsUseCase.execute()
    }

    public func selectStream(_ stream: HLSStream) {
        selectedSteam = stream
    }
}

public struct HLSDemoPage: View {
    @StateObject private var viewModel: HLSDemoViewModel

    public init(viewModel: HLSDemoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        List(viewModel.streams, id: \.id) { stream in
            Button {
                viewModel.selectStream(stream)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(stream.title)
                        .font(.headline)
                    if let desc = stream.description {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("HLS Demo")
        .onAppear { viewModel.onAppear() }
        .sheet(item: $viewModel.selectedSteam) { stream in
            HLSPlayerView(url: stream.url)
                .ignoresSafeArea()
        }
        .tint(.white)
    }
}

public struct HLSPlayerView: UIViewControllerRepresentable {
    let url: URL

    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: url)
        controller.player?.play()
        return controller
    }

    public func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }
}

public struct LightHLSPlayerView: View {
    let url: URL
    @State private var player: AVPlayer?

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                // 한 번만 생성
                if player == nil {
                    player = AVPlayer(url: url)
                }
                player?.play()
            }
            .onDisappear {
                player?.pause()
            }
            .ignoresSafeArea()
    }
}
