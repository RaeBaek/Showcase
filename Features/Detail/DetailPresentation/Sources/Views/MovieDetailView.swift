//
//  MovieDetailView.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI
import AVKit

public struct MovieDetailView: View {
    @ObservedObject private var viewModel: MovieDetailViewModel

    public init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                LoadingSkeleton()
                    .onAppear { viewModel.load() }
            case .failed(let message):
                VStack(spacing: 12) {
                    Text("로딩 실패")
                        .font(.headline)
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("다시 시도") { viewModel.load() }
                }
                .padding(.top, 80)
            case .loaded:
                if let detail = viewModel.detail {
                    ScrollView {
                        VStack {
                            HeaderBackdrop(detail: detail)

                        }
                    }
                }
            }
        }
    }
}
