//
//  PlaceholderCreditView.swift
//  DesignSystem
//
//  Created by 백래훈 on 11/21/25.
//

import SwiftUI

public struct PlaceholderCreditView: View {
    private let width: CGFloat
    private let height: CGFloat

    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    public var body: some View {
        Circle()
            .fill(.gray.opacity(0.3))
            .overlay(Image(systemName: "person").imageScale(.medium))
            .frame(width: 70, height: 70)
    }
}
