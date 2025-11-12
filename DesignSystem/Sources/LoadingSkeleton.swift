//
//  LoadingSkeleton.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI

public struct LoadingSkeleton: View {

    public init() { }

    public var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Rectangle().fill(.gray.opacity(0.25)).frame(height: 260)
                ForEach(0..<6) { _ in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 18)
                        .padding(.horizontal, 16)
                }
                Spacer(minLength: 40)
            }
        }
        .redacted(reason: .placeholder)
    }
}
