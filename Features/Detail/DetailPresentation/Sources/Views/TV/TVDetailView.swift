//
//  TVDetailView.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI

import NavigationInterface
import DetailDomain

public struct TVDetailView: View {
    @ObservedObject private var viewModel: TVDetailViewModel

    private let onNavigate: (Route) -> Void

    public init(
        viewModel: TVDetailViewModel,
        onNavigate: @escaping (Route) -> Void
    ) {
        self.viewModel = viewModel
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
                    Text("로딩 실패")
                        .font(.headline)
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("다시 시도") { viewModel.load() }
                }
                .padding(.top, 80)
            case .loaded:
                if let adapter = viewModel.tvState.adater {
                    ScrollView {
                        VStack(spacing: 24) {
                            HeaderBackdrop(model: adapter)
                            ActionBar()
                            OverviewSection(text: adapter.overviewText, expanded: $viewModel.tvState.showFullOverview)
                        }
                        if !viewModel.tvState.credits.isEmpty {
                            CreditSection(credits: viewModel.tvState.credits)
                        }
                        if !viewModel.tvState.similars.isEmpty {
                            SimilarSection(list: viewModel.tvState.similars) { item in
                                onNavigate(.movieDetail(id: Int32(item.id)))
                            }
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                }
            }
        }
    }
}
