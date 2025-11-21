//
//  CreditSection.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/5/25.
//

import SwiftUI

import Localization
import DetailDomain

import Kingfisher

public struct CreditSection: View {

    let credits: [CreditInfoEntity]
    let onItemTap: ((CreditInfoEntity) -> Void)?

    public init(credits: [CreditInfoEntity], onItemTap: ((CreditInfoEntity) -> Void)?) {
        self.credits = credits
        self.onItemTap = onItemTap
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: L10n.MovieTVDetail.detailProduction)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(credits) { credit in
                        VStack(spacing: 6) {
                            if let url = credit.profileURL {
                                KFCreditView(url: url, width: 70, height: 70)
                            } else {
                                PlaceholderCreditView(width: 70, height: 70)
                            }

                            Text(credit.name)
                                .font(.footnote)
                                .lineLimit(1)

                            Text(credit.role ?? "")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        .frame(width: 90)
                        .onTapGesture {
                            onItemTap?(credit)
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }
}
