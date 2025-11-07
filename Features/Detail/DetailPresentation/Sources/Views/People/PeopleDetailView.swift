//
//  PersonDetailView.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI

public struct PeopleDetailView: View {
    @ObservedObject private var viewModel: PeopleDetailViewModel
    @State private var showFullBio = false

    public init(viewModel: PeopleDetailViewModel) {
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
                    Image(systemName: "wifi.exclamationmark")
                    Text(message)
                }
                .foregroundStyle(.secondary)
                .padding(.top, 80)
            case .loaded:
//                if let detail = viewModel.detail,
//                   let knownFors = viewModel.knownFors,
//                   let biography = detail.biography {
//                    ScrollView(.vertical, showsIndicators: false) {
//                        VStack(alignment: .leading, spacing: 24) {
//                            HeroHeader(person: detail)
//                            MetaGrid(person: detail)
//                            BiographySection(text: biography, showFull: $showFullBio)
//
//                            if !knownFors.isEmpty {
//                                KnownForSection(items: knownFors) { item in
//                                    // TODO: route로 상세 화면 push (Movie or TV Detail)
//                                }
//                            }
//                            Spacer(minLength: 40)
//                        }
//                        .padding(.horizontal, 16)
//                        .padding(.top, 8)
//                    }
//                    .ignoresSafeArea(edges: .top)
//                    .navigationTitle("")
//                }
                if let detail = viewModel.detail,
                   let biography = detail.biography {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            HeroHeader(person: detail)
                            MetaGrid(person: detail)
                            BiographySection(text: biography, showFull: $showFullBio)

//                            if !knownFors.isEmpty {
//                                KnownForSection(items: knownFors) { item in
//                                    // TODO: route로 상세 화면 push (Movie or TV Detail)
//                                }
//                            }
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
//                    .ignoresSafeArea(edges: .top)
                    .navigationTitle("")
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}

// 3651176
