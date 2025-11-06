//
//  OverviewSection.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/5/25.
//

import SwiftUI

struct OverviewSection: View {
    let text: String
    @Binding var expanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "개요")

            Text(text.isEmpty ? "줄거리 정보가 없습니다." : text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(expanded ? nil : 4)
                .animation(.easeInOut, value: expanded)

            if text.count > 120 {
                Button(expanded ? "접기" : "더보기") {
                    expanded.toggle()
                }
                .font(.footnote.weight(.semibold))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
