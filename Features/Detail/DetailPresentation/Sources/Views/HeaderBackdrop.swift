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
    let detail: MovieDetailEntity

    var metaText: String {
        let year = detail.releaseDate?.prefix(4) ?? ""
        let genres = detail.genres.prefix(3).joined(separator: " · ")
        var arr: [String] = []
        if !year.isEmpty { arr.append(String(year)) }
        if let r = detail.runtime { arr.append("\(r)분") }
        if !genres.isEmpty { arr.append(genres) }
        return arr.joined(separator: "  •  ")
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let imageURL = detail.backdropURL {
                KFImage(imageURL)
                    .resizable()
                    .placeholder {
                        Color.black.opacity(0.7)
                        ProgressView()
                    }
                    .onFailure { error in
                        print("이미지 로드 실패: \(error.localizedDescription)")
                    }
                    .scaledToFill()
                    .frame(height: 260)
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
                    .offset(y: 30)

                VStack(alignment: .leading, spacing: 6) {
                    Text(detail.title)
                        .font(.title2.weight(.bold))
                        .lineLimit(2)

                    if let original = detail.originalTitle, original != detail.title {
                        Text(original)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "star.fill").font(.caption)
                        Text(String(format: "%.1f", detail.voteAverage))
                        Text(metaText)
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
        .shadow(radius: 6, y: 3)
    }
}
