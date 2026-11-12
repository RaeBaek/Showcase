//
//  HLSDemoViewModel.swift
//  StreamingPresentation
//
//  Created by 백래훈 on 11/13/25.
//

import SwiftUI
import AVFAudio
import AVKit

import DesignSystem
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
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 24) {
                ForEach(viewModel.streams, id: \.id) { stream in
                    Button {
                        viewModel.selectStream(stream)
                    } label: {
                        HLSDemoRow(stream: stream)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 16)
            .customBackToolbar()
        }
        .padding(16)
        .navigationTitle("HTTP Live Streaming")
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

    public final class Coordinator {
        fileprivate var playbackTask: Task<Void, Never>?
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        let player = AVPlayer(url: url)
        controller.player = player
        context.coordinator.playbackTask = Task {
            await player.playStream()
        }
        return controller
    }

    public func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }

    public static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        coordinator.playbackTask?.cancel()
    }
}

public struct LightHLSPlayerView: View {
    let url: URL
    @State private var player: AVPlayer?

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        VideoPlayer(player: player)
            .task {
                // 한 번만 생성
                if player == nil {
                    player = AVPlayer(url: url)
                }
                await player?.playStream()
            }
            .onDisappear {
                player?.pause()
            }
            .ignoresSafeArea()
    }
}

private extension AVPlayer {
    @MainActor
    func playStream() async {
        guard !Task.isCancelled else { return }

        await Task.detached(priority: .userInitiated) {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            } catch {
                print("⚠️ AVAudioSession 설정 실패: \(error)")
            }
        }.value

        guard !Task.isCancelled else { return }
        play()
    }
}
