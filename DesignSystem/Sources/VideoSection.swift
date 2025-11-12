//
//  VideoSection.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/5/25.
//

import SwiftUI
import DetailDomain
import Kingfisher

public struct VideoSection: View {
    
    let videos: [VideoItemEntity]

    public init(videos: [VideoItemEntity]) {
        self.videos = videos
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "영상")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(videos) { video in
                        ZStack(alignment: .center) {
                            if video.site.lowercased() == "youtube",
                               let thumbURL = video.thumbnailURL {
                                KFImage(thumbURL)
                                    .resizable()
                                    .placeholder {
                                        Color.black.opacity(0.7)
                                        ProgressView()
                                    }
                                    .onFailure { error in
                                        print("썸네일 이미지 로드 실패: \(error.localizedDescription)")
                                    }
                                    .scaledToFill()
                                    .frame(width: 260, height: 146)
                                    .clipped()
                            } else {
                                Rectangle().fill(.gray.opacity(0.25))
                                    .frame(width: 260, height: 146)
                            }
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 44))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(alignment: .bottomLeading) {
                            Text(video.name)
                                .font(.caption)
                                .lineLimit(1)
                                .padding(8)
                                .background(.black.opacity(0.5), in: Capsule())
                                .padding(8)
                        }
                        .onTapGesture {
                            if video.site.lowercased() == "youtube",
                               let watchURL = video.watchURL {
                                UIApplication.shared.open(watchURL)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }
}

