//
//  PersonDetailView.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI

import DesignSystem
import NavigationInterface
import DetailDomain

public struct PeopleDetailView: View {
    @StateObject private var viewModel: PeopleDetailViewModel

    private let onNavigate: (Route) -> Void

    public init(
        viewModel: PeopleDetailViewModel,
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
                if let detail = viewModel.detail,
                   let knownFors = viewModel.knownFors,
                   let biography = detail.biography {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            HeroHeader(person: detail)
                            MetaGrid(person: detail)
                            BiographySection(text: biography, showFull: $viewModel.showFullBio)

                            if !knownFors.isEmpty {
                                KnownForSection(items: knownFors) { item in
                                    switch item.media {
                                    case .movie:
                                        onNavigate(.movieDetail(id:  Int32(item.id)))
                                    case .tv:
                                        onNavigate(.tvDetail(id: Int32(item.id)))
                                    }
                                }
                            }
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
        }
        .customBackToolbar()
        .background(Color.black.ignoresSafeArea())
    }
}
