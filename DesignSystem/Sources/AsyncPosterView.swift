//
//  PosterView.swift
//  DesignSystem
//
//  Created by 백래훈 on 11/19/25.
//

import SwiftUI

public struct AsyncPosterView: View {

    private let url: URL?
    private let width: CGFloat
    private let height: CGFloat

    public init(
        url: URL?,
        width: CGFloat,
        height: CGFloat
    ) {
        self.url = url
        self.width = width
        self.height = height
    }

    public var body: some View {
        AsyncImage(url: url) { img in
            img.resizable().scaledToFill()
        } placeholder: {
            Rectangle().fill(.gray.opacity(0.3))
                .overlay(Image(systemName: "film").imageScale(.large))
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
