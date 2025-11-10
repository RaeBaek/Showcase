//
//  TVDetailView.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI
import Kingfisher

struct TVDetailView: View {
    @ObservedObject private var viewModel: TVDetailViewModel

    init(viewModel: TVDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let detail = viewModel.tvState.detail {
                    HeaderBackdrop(detail: detail)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(detail.)
                    }
                }
            }
        }
    }
}
