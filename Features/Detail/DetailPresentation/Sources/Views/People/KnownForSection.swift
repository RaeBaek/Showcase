//
//  KnownForSection.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/7/25.
//

import SwiftUI
import DetailDomain
import Kingfisher

struct KnownForSection: View {
    let items: [KnownForItem]
    let onSelect: (KnownForItem) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 14) {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        if let url = item.posterURL {
                            KFImage(url)
                                .placeholder {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(.gray.opacity(0.2))
                                        .frame(width: 120, height: 170)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 170)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .onTapGesture {
                                    onSelect(item)
                                }
                        }
                        Text(item.title)
                            .font(.footnote)
                            .lineLimit(2)
                            .frame(width: 120, alignment: .leading)

                        HStack(spacing: 6) {
                            if let year = item.yearText {
                                Text(year)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Text(item.media == .movie ? "Movie" : "TV")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }
}
