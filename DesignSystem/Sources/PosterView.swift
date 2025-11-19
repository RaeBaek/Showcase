//
//  PosterView.swift
//  DesignSystem
//
//  Created by 백래훈 on 11/19/25.
//

import SwiftUI

public struct PosterView: View {

    let url: URL?

    public var body: some View {
        AsyncImage(url: url) { img in
            img.resizable().scaledToFill()
        } placeholder: {
            Rectangle().fill(.gray.opacity(0.3))
                .overlay(Image(systemName: "film").imageScale(.large))
        }
        .frame(width: 110, height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
