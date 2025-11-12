//
//  SectionHeader.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/5/25.
//

import SwiftUI

public struct SectionHeader: View {
    
    let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
}
