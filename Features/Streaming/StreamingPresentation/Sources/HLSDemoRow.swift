//
//  HLSDemoRow.swift
//  StreamingPresentation
//
//  Created by 백래훈 on 11/13/25.
//

import SwiftUI

import StreamingDomain

struct HLSDemoRow: View {
    let stream: HLSStream
    @State private var thumbnail: UIImage?

    var body: some View {
        ZStack(alignment: .center) {
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
            }
            // 재생 아이콘
            Image(systemName: "play.circle.fill")
                .font(.system(size: 44, weight: .regular))
                .foregroundStyle(.white)
                .shadow(radius: 6)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .bottomLeading) {
            titleOverlay
        }
        .shadow(radius: 6)
        .task {
            if thumbnail == nil {
                let generator = HLSThumbnailGenerator()
                if let image = await generator.generateThumbnail(from: stream.url) {
                    thumbnail = image
                }
            }
        }
    }

    private var titleOverlay: some View {
        // 하단 타이틀/서브타이틀 오버레이
        VStack(alignment: .leading, spacing: 4) {
            Text(stream.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.top, 8)
                .padding(.horizontal, 8)

            if let desc = stream.description {
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
            }
        }
        .background(
            Color.black.opacity(0.6)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        )
        .padding(.leading, 8)
        .padding(.bottom, 8)
    }
}

