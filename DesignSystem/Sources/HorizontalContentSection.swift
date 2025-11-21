//
//  HorizontalContentSection.swift
//  DesignSystem
//
//  Created by 백래훈 on 11/21/25.
//

import SwiftUI

import DetailDomain

public struct HorizontalContentSection<Item: HorizontalContentDisplayable, Footer: View>: View {

    let title: String
    let items: [Item]
    let onItemTap: ((Item) -> Void)?
    let footer: (Item) -> Footer

    public init(
        title: String,
        items: [Item],
        onItemTap: ((Item) -> Void)? = nil,
        @ViewBuilder footer: @escaping (Item) -> Footer
    ) {
        self.title = title
        self.items = items
        self.onItemTap = onItemTap
        self.footer = footer
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: title)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 12) {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            // Poster & Title
                            poster(item)
                            titleView(item)
                            // footer
                            footer(item)
                        }
                        .onTapGesture { onItemTap?(item) }
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func poster(_ item: Item) -> some View {
        if let url = item.posterURL {
            KFPosterView(url: url, width: 120, height: 180)
        } else {
            PlaceholderPosterView(width: 120, height: 180)
        }
    }

    @ViewBuilder
    private func titleView(_ item: Item) -> some View {
        Text(item.titleText)
            .font(.caption)
            .lineLimit(2)
            .frame(width: 120, alignment: .leading)
    }
}
