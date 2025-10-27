//
//  HomeSectionView.swift
//  HomePresentation
//
//  Created by 백래훈 on 10/26/25.
//

import SwiftUI
import HomeDomain

struct SectionView<T: HomeDisplayable>: View {
    let title: String
    let items: [T]
    let onItemAppear: ((T) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.bold())
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(items) { item in
                        LazyVStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 12)
                                .overlay {
                                    if let imageURL = item.imageURL {
                                        AsyncImage(url: imageURL) { img in
                                            if let image = img.image {
                                                image.resizable().scaledToFill()
                                            } else if img.error != nil {
                                                Color.black.opacity(0.7)
                                            } else {
                                                ZStack {
                                                    Color.black.opacity(0.7)
                                                    ProgressView()
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(width: 120, height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(item.displayTitle)
                                .lineLimit(1)
                                .font(.subheadline).bold()
                                .frame(width: 120, alignment: .leading)
                        }
                        .onAppear {
                            onItemAppear?(item) // item이 보일 때 마다 트리거
                        }
                    }
                }
                .padding(.trailing, 16)
            }
        }
    }
}
