//
//  MetaGrid.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/6/25.
//

import SwiftUI

import DesignSystem
import DetailDomain

struct MetaGrid: View {
    let person: PersonDetailEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "인물 정보")
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                MetaItem(icon: "calendar", title: "Born", value: person.birthday ?? "-")
                if let deathday = person.deathday {
                    MetaItem(icon: "cross", title: "Died", value: deathday)
                }
                MetaItem(icon: "mappin.and.ellipse", title: "Birthplace", value: person.placeOfBirth ?? "-")
                if let site = person.homepage, !site.isEmpty {
                    Link(destination: URL(string: site)!) {
                        MetaItem(icon: "safari", title: "Website", value: site)
                    }
                    .buttonStyle(.plain)
                } else {
                    MetaItem(icon: "safari", title: "Website", value: "-")
                }
            }
        }
    }
}

struct MetaItem: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .frame(width: 18)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
