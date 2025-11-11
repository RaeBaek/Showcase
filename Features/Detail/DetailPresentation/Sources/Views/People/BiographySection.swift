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
            
            Text(text.isEmpty ? "일대기 정보가 없습니다." : text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(showFull ? nil : 4)
                .animation(.easeInOut, value: showFull)

            if text.count > 120 {
                Button(showFull ? "접기" : "더보기") {
                    showFull.toggle()
                }
                .font(.footnote.weight(.semibold))
                .tint(.white)
            }
        }
    }
}
