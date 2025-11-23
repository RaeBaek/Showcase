//
//  MetaGrid.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/6/25.
//

import SwiftUI

import DesignSystem
import Localization
import DetailDomain

struct MetaGrid: View {
    let person: PersonDetailEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: L10n.PeopleDetail.detailInfo)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                MetaItem(icon: "calendar", title: L10n.PeopleDetail.detailBorn, value: person.birthday ?? "-")
                if let deathday = person.deathday {
                    MetaItem(icon: "cross", title: L10n.PeopleDetail.detailDied, value: deathday)
                }
                MetaItem(icon: "mappin.and.ellipse", title: L10n.PeopleDetail.detailBirthplace, value: person.placeOfBirth ?? "-")
                if let site = person.homepage, !site.isEmpty {
                    Link(destination: URL(string: site)!) {
                        MetaItem(icon: "safari", title: L10n.PeopleDetail.detailWebsite, value: site)
                    }
                    .buttonStyle(.plain)
                } else {
                    MetaItem(icon: "safari", title: L10n.PeopleDetail.detailWebsite, value: "-")
                }
            }
        }
        .padding(.horizontal, 16)
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
