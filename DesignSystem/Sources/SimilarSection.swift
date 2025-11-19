//
//  SimilarSection.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/5/25.
//

import SwiftUI

import Localization
import DetailDomain

import Kingfisher

public struct SimilarSection: View {
    
    let list: [SimilarItemEntity]
    let onItemTap: ((SimilarItemEntity) -> Void)?

    public init(list: [SimilarItemEntity], onItemTap: ((SimilarItemEntity) -> Void)?) {
        self.list = list
        self.onItemTap = onItemTap
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: L10n.MovieTVDetail.detailSimilarPiece)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(list) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            if let posterUrl = item.posterURL {
                                KFImage(posterUrl)
                                    .resizable()
                                    .placeholder {
                                        Color.black.opacity(0.7)
                                        ProgressView()
                                    }
                                    .onFailure { error in
                                        print("이미지 로드 실패: \(error.localizedDescription)")
                                    }
                                    .scaledToFill()
                                    .frame(width: 120, height: 180)
                                    .clipped()
                                    .background(Color.black.opacity(0.08))
                            } else {
                                Rectangle().fill(.gray.opacity(0.3))
                                    .overlay(Image(systemName: "film").imageScale(.medium))
                                    .frame(width: 120, height: 180)
                            }
                            Text(item.title ?? "")
                                .font(.caption)
                                .lineLimit(2)
                                .frame(width: 120, alignment: .leading)
                        }
                        .onTapGesture {
                            onItemTap?(item)
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }
}
