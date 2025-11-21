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
        HorizontalContentSection(title: L10n.PeopleDetail.detailOtherPiece, items: items) { item in
            onSelect(item)
        } footer: { item in
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
