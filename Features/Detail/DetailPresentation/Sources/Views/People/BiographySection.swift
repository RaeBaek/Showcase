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
            Text("Biography")
                .font(.title3.bold())
            Text(text.isEmpty ? "No biography" : text)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(showFull ? nil : 5)
                .animation(.easeInOut, value: showFull)
            if text.count > 0 {
                Button(showFull ? "show less" : "Read more") {
                    showFull.toggle()
                }
                .font(.footnote.bold())
            }
        }
    }
}
