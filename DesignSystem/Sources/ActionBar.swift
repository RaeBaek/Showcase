//
//  ActionBar.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI

import Localization

public struct ActionBar: View {

    public init() { }
    
    public var body: some View {
        HStack(spacing: 12) {
            Button {
                // 재생
            } label: {
                HStack {
                    Image(systemName: "play.fill")
                    Text(L10n.MovieTVDetail.detailPlay)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .backgroundStyle(.black)
                .foregroundStyle(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 1)
                }
            }

            Button {
                // 찜
            } label: {
                VStack(spacing: 3) {
                    Image(systemName: "plus")
                    Text(L10n.MovieTVDetail.detailMyList)
                        .font(.caption2)
                }
                .frame(width: 90)
                .tint(.white)
            }

            Button {
                // 평가
            } label: {
                VStack(spacing: 3) {
                    Image(systemName: "hand.thumbsup")
                    Text(L10n.MovieTVDetail.detailEvaluation)
                        .font(.caption2)
                }
                .frame(width: 60)
                .tint(.white)
            }

            Button {
                // 공유
            } label: {
                VStack(spacing: 3) {
                    Image(systemName: "paperplane")
                    Text(L10n.MovieTVDetail.detailShare)
                        .font(.caption2)
                }
                .frame(width: 60)
                .tint(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }
}
