//
//  BiographySection.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/6/25.
//

import SwiftUI

struct BiographySection: View {
    let text: String
    @Binding var showFull: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "일대기")
            
            Text(text.isEmpty ? "No biography" : text)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(showFull ? nil : 5)
                .animation(.easeInOut, value: showFull)
            if text.count > 0 {
                Button(showFull ? "접기" : "더보기") {
                    showFull.toggle()
                }
                .font(.footnote.bold())
            }
        }
    }
}
