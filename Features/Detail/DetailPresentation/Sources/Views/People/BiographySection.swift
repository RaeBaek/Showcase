//
//  BiographySection.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/6/25.
//

import SwiftUI

import DesignSystem
import Localization

struct BiographySection: View {
    let text: String
    @Binding var showFull: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: L10n.PeopleDetail.detailBiography)

            Text(text.isEmpty ? L10n.PeopleDetail.detailNoBiography : text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(showFull ? nil : 4)
                .animation(.easeInOut, value: showFull)

            if text.count > 120 {
                Button(showFull ? L10n.Common.commonLess : L10n.Common.commonMore) {
                    showFull.toggle()
                }
                .font(.footnote.weight(.semibold))
                .tint(.white)
            }
        }
        .padding(.horizontal, 16)
    }
}
