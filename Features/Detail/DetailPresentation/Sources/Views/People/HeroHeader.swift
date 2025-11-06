//
//  HeroHeader.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/6/25.
//

import SwiftUI
import DetailDomain

import Kingfisher

struct HeroHeader: View {
    let person: PersonEntity

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            KFImage(URL(string: "https://www.naver.com"))
                .placeholder {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.gray.opacity(0.2))
                        .frame(width: 120, height: 160)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(alignment: .bottomLeading) {
                    if person.popularity > 0 {
                        Label(String(format: "%.1f", person.popularity), systemImage: "star.fill")
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.black.opacity(0.6), in: Capsule())
                            .padding(6)
                    }
                }
            VStack(alignment: .leading, spacing: 8) {
                Text(person.name)
                    .font(.system(size: 28, weight: .bold))
                Text(person.knownForDepartment)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}
