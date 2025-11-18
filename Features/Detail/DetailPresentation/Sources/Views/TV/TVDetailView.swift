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
            switch viewModel.tvDetailState.state {
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
                if let adapter = viewModel.tvDetailState.adater {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            HeaderBackdrop(model: adapter)
                            ActionBar()
                            OverviewSection(
                                text: adapter.overviewText,
                                expanded: Binding(
                                    get: {
                                        viewModel.tvDetailState.showFullOverview
                                    },
                                    set: { _ in
                                        viewModel.toggleOverviewExpanded()
                                    }
                                )
                            )
                            if !viewModel.tvDetailState.credits.isEmpty {
                                CreditSection(credits: viewModel.tvDetailState.credits) { credit in
                                    onNavigate(.personDetail(id: Int32(credit.id)))
                                }
                            }
                            if !viewModel.tvDetailState.videos.isEmpty {
                                VideoSection(videos: viewModel.tvDetailState.videos)
                            }
                            if !viewModel.tvDetailState.similars.isEmpty {
                                SimilarSection(list: viewModel.tvDetailState.similars) { item in
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
