//
//  ShowcaseApp.swift
//  Showcase
//
//  Created by 백래훈 on 10/23/25.
//

import SwiftUI

import AVFAudio

import NavigationInterface
import NetworkLive

import HomePresentation
import DetailPresentation
import StreamingPresentation

@main
struct ShowcaseApp: App {
    @StateObject private var navigator = AppNavigator()
    private let container = DIContainer(httpClient: TMDBClient())

    init() {
        configureAudioSession()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigator.path) {
                HomeView(viewModel: container.makeHomeViewModel()) { item in
                    navigator.push(item)
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .movieDetail(let id):
                        MovieDetailView(viewModel: container.makeMovieDetailViewModel(id: id)) { item in
                            navigator.push(item)
                        }
                        .background(EnableBackSwipeGesture())
                    case .personDetail(let id):
                        PeopleDetailView(viewModel: container.makePeopleDetailViewModel(id: id)) { item in
                            navigator.push(item)
                        }
                        .background(EnableBackSwipeGesture())
                    case .tvDetail(let id):
                        TVDetailView(viewModel: container.makeTVDetailViewModel(id: id)) { item in
                            navigator.push(item)
                        }
                        .background(EnableBackSwipeGesture())
                    case .hlsDemo:
                        HLSDemoPage(viewModel: container.makeHLSDemoViewModel())
                            .background(EnableBackSwipeGesture())
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            // 무음 모드여도 재생 가능
            try session.setCategory(.playback, mode: .moviePlayback, options: [])
            try session.setActive(true)
        } catch {
            print("⚠️ AVAudioSession 설정 실패: \(error)")
        }
    }
}
