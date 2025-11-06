//
//  ActionBar.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI

struct ActionBar: View {
    var body: some View {
        HStack(spacing: 12) {
            Button {
                // 재생
            } label: {
                HStack {
                    Image(systemName: "play.fill")
                    Text("재생")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                // 찜
            } label: {
                VStack(spacing: 3) {
                    Image(systemName: "plus")
                    Text("내가 찜한 리스트")
                        .font(.caption2)
                }
                .frame(width: 90)
            }

            Button {
                // 평가
            } label: {
                VStack(spacing: 3) {
                    Image(systemName: "hand.thumbsup")
                    Text("평가")
                        .font(.caption2)
                }
                .frame(width: 60)
            }

            Button {
                // 공유
            } label: {
                VStack(spacing: 3) {
                    Image(systemName: "paperplane")
                    Text("공유")
                        .font(.caption2)
                }
                .frame(width: 60)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }
}
