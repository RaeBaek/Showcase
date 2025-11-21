//
//  KFPosterView.swift
//  DesignSystem
//
//  Created by 백래훈 on 11/21/25.
//

import SwiftUI

import Kingfisher

public struct KFPosterView: View {
    private let url: URL
    private let width: CGFloat
    private let height: CGFloat

    public init(url: URL, width: CGFloat, height: CGFloat) {
        self.url = url
        self.width = width
        self.height = height
    }

    public var body: some View {
        KFImage(url)
            .resizable()
            .placeholder {
                Color.black.opacity(0.7)
                ProgressView()
            }
            .onFailure { error in
                print("이미지 로드 실패: \(error.localizedDescription)")
            }
            .scaledToFill()
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(Color.black.opacity(0.08))
    }
}
