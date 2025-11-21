//
//  PlaceholderPosterView.swift
//  DesignSystem
//
//  Created by 백래훈 on 11/21/25.
//

import SwiftUI

public struct PlaceholderPosterView: View {
    private let width: CGFloat
    private let height: CGFloat

    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.gray.opacity(0.3))
            .overlay(Image(systemName: "film").imageScale(.medium))
            .frame(width: width, height: height)
    }
}
