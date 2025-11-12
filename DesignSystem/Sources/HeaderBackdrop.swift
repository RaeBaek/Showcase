//
//  HeaderBackdrop.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI

import DetailDomain
import Kingfisher

public struct HeaderBackdrop<Model: HeaderBackdropPresentable>: View {

    let model: Model
    let targetWidth  = UIScreen.main.bounds.width
    let targetHeight: CGFloat = 350

    @State private var ratio: CGFloat = 9.0/16.0 // 임시 비율

    public init(model: Model) {
        self.model = model
    }

    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let url = model.backdropURL {
                KFImage(url)
                    .setProcessor(
                        ResizingImageProcessor(
                            referenceSize: CGSize(
                                width: targetWidth * UIScreen.main.scale,
                                height: targetHeight * UIScreen.main.scale
                            ),
                            mode: .aspectFill
                        )
                    )
                    .placeholder {
                        Rectangle().fill(.gray.opacity(0.3))
                            .overlay(Image(systemName: "film").imageScale(.large))
                    }
                    .onSuccess { result in
                        let sz = result.image.size
                        if sz.width > 0 { ratio = sz.width / sz.height }
                    }
                    .cacheOriginalImage()
                    .fade(duration: 0.2)
                    .resizable()
                    .aspectRatio(ratio, contentMode: .fill)
                    .frame(width: targetWidth, height: targetHeight)
                    .clipped()
            } else {
                Rectangle().fill(.gray.opacity(0.3))
                    .overlay(Image(systemName: "film").imageScale(.large))
                    .frame(width: targetWidth, height: targetHeight)
            }
            // 그라디언트 오버레이
            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 160)
            .frame(maxWidth: .infinity, alignment: .bottom)
            .offset(y: 0)

            HStack(alignment: .bottom, spacing: 12) {
                PosterView(url: model.posterURL)
                    .offset(y: 0)

                VStack(alignment: .leading, spacing: 6) {
                    Text(model.titleText)
                        .font(.title2.weight(.bold))
                        .lineLimit(2)

                    if let original = model.originalTitleText {
                        Text(original)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(alignment: .top, spacing: 8) {
                        Text(model.ratingText)
                        VStack(alignment: .leading) {
                            Text(model.metaText)
                            Text(model.genresText)
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}

private struct PosterView: View {
    let url: URL?
    var body: some View {
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
