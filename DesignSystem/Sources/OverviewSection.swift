//
//  OverviewSection.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/5/25.
//

import SwiftUI

import Localization

public struct OverviewSection: View {
    
    let text: String
    @Binding var expanded: Bool

    public init(text: String, expanded: Binding<Bool>) {
        self.text = text
        _expanded = expanded
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: L10n.MovieTVDetail.detailOverview)

            Text(text.isEmpty ? L10n.MovieTVDetail.detailNoOverview : text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(expanded ? nil : 4)
                .animation(.easeInOut, value: expanded)

            if text.count > 120 {
                Button(expanded ? L10n.Common.commonLess : L10n.Common.commonMore) {
                    expanded.toggle()
                }
                .font(.footnote.weight(.semibold))
                .tint(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
