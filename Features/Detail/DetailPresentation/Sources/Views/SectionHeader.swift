//
//  SectionHeader.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/5/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
}
