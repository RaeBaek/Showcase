//
//  TVDetailView.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI

import DesignSystem
import NavigationInterface
import DetailDomain

public struct TVDetailView: View {
    @StateObject private var viewModel: TVDetailViewModel

    private let onNavigate: (Route) -> Void

    public init(
        viewModel: TVDetailViewModel,
        onNavigate: @escaping (Route) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNavigate = onNavigate
    }

    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                LoadingSkeleton()
                    .onAppear { viewModel.load() }
            case .failed(let message):
                VStack(spacing: 12) {
                    Image(systemName: "wifi.exclamationmark")
                    Text(message)
                        .font(.subheadline)
                    Button("다시 시도") { viewModel.load() }
                }
                .foregroundStyle(.secondary)
                .padding(.top, 80)
            case .loaded:
                if let adapter = viewModel.tvState.adater {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            HeaderBackdrop(model: adapter)
                            ActionBar()
                            OverviewSection(
                                text: adapter.overviewText,
                                expanded: $viewModel.tvState.showFullOverview
                            )
                            if !viewModel.tvState.credits.isEmpty {
                                CreditSection(credits: viewModel.tvState.credits) { credit in
                                    onNavigate(.personDetail(id: Int32(credit.id)))
                                }
                            }
                            if !viewModel.tvState.videos.isEmpty {
                                VideoSection(videos: viewModel.tvState.videos)
                            }
                            if !viewModel.tvState.similars.isEmpty {
                                SimilarSection(list: viewModel.tvState.similars) { item in
                                    onNavigate(.tvDetail(id: Int32(item.id)))
                                }
                            }
                            Spacer(minLength: 40)
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                }
            }
        }
        .customBackToolbar()
    }
}
