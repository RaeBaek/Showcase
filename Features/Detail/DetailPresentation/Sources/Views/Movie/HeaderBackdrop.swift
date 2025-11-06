//
//  HeaderBackdrop.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI
import DetailDomain
import Kingfisher

struct HeaderBackdrop: View {
    let detail: MovieDetailInfoEntity

    var metaText: String {
        let year = detail.releaseDate?.prefix(4) ?? ""
        var arr: [String] = []
        if !year.isEmpty { arr.append(String(year)) }
        if let r = detail.runtime { arr.append("\(r)분") }
        return arr.joined(separator: " · ")
    }

    var genres: String {
        return detail.genres.map { $0.name }.prefix(3).joined(separator: " · ")
    }

    let targetWidth  = UIScreen.main.bounds.width
    let targetHeight: CGFloat = 350

    @State private var ratio: CGFloat = 9.0/16.0 // 임시 비율

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let url = detail.backdropURL {
                KFImage(url)
                    .setProcessor(
                        ResizingImageProcessor(
                            referenceSize: CGSize(
                                width: targetWidth * UIScreen.main.scale,
                                height: targetHeight * UIScreen.main.scale
                            ),
                            mode: .aspectFill // ✅ 높이 350에 맞게 확대 + 크롭
                        )
                    )
                    .onSuccess { result in
                        let sz = result.image.size
                        if sz.width > 0 { ratio = sz.width / sz.height }
                    }
                    .cacheOriginalImage()
                    .fade(duration: 0.2)
                    .resizable()
                    .aspectRatio(ratio, contentMode: .fill)  // ✅ 비율 유지 + 채우기(확대)
                    .frame(width: targetWidth, height: targetHeight)
                    .clipped()
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
                PosterView(url: detail.posterURL)
                    .offset(y: 0)

                VStack(alignment: .leading, spacing: 6) {
                    Text(detail.title)
                        .font(.title2.weight(.bold))
                        .lineLimit(2)

                    if let original = detail.originalTitle, original != detail.title {
                        Text(original)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "star.fill").font(.caption)
                        Text(String(format: "%.1f", detail.voteAverage))
                        VStack(alignment: .leading) {
                            Text(metaText)
                            Text(genres)
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
        //        .shadow(radius: 6, y: 3)
    }
}
