//
//  KnownForSection.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/7/25.
//

import SwiftUI

import DesignSystem
import Localization
import DetailDomain

import Kingfisher

struct KnownForSection: View {
    let items: [KnownForItem]
    let onSelect: (KnownForItem) -> Void

    var body: some View {
        VStack {
            SectionHeader(title: L10n.PeopleDetail.detailOtherPiece)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 14) {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            if let url = item.posterURL {
                                KFImage(url)
                                    .placeholder {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.gray.opacity(0.2))
                                            .frame(width: 120, height: 180)
                                    }
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .onTapGesture {
                                        onSelect(item)
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.gray.opacity(0.3))
                                    .overlay(Image(systemName: "film").imageScale(.medium))
                                    .frame(width: 120, height: 180)
                            }
                            Text(item.title)
                                .font(.footnote)
                                .lineLimit(2)
                                .frame(width: 120, alignment: .leading)

                            HStack(spacing: 4) {
                                Text(item.media == .movie ? "Movie" : "TV")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                if let year = item.year {
                                    Text(year)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}
