//
//  ActionBar.swift
//  DetailPresentation
//
//  Created by 백래훈 on 11/1/25.
//

import SwiftUI
import DetailDomain
import Kingfisher

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

struct OverviewSection: View {
    let text: String
    @Binding var expanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "개요")

            Text(text.isEmpty ? "줄거리 정보가 없습니다." : text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(expanded ? nil : 4)
                .animation(.easeInOut, value: expanded)

            if text.count > 120 {
                Button(expanded ? "접기" : "더보기") {
                    expanded.toggle()
                }
                .font(.footnote.weight(.semibold))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

private struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
}

struct CreditSection: View {
    let credits: [CreditPersonEntity]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "출연/제작")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(credits) { credit in
                        VStack(spacing: 6) {
                            if let profileURL = credit.profileURL {
                                KFImage(profileURL)
                                    .resizable()
                                    .placeholder {
                                        Color.black.opacity(0.7)
                                        ProgressView()
                                    }
                                    .onFailure { error in
                                        print("이미지 로드 실패: \(error.localizedDescription)")
                                    }
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())

                                Text(credit.name)
                                    .font(.footnote)
                                    .lineLimit(1)

                                Text(credit.role ?? "")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        .frame(width: 90)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 16)
    }
}

struct VideoSection: View {
    let videos: [VideoItemEntity]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "영상")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(videos) { video in
                        ZStack(alignment: .center) {
                            Rectangle().fill(.gray.opacity(0.25))
                                .frame(width: 260, height: 146)
                                .overlay(
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 44))
                                )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(alignment: .bottomLeading) {
                            Text(video.name)
                                .font(.caption)
                                .lineLimit(1)
                                .padding(8)
                                .background(.black.opacity(0.5), in: Capsule())
                                .padding(8)
                        }
                        .onTapGesture {
                            // YouTube로 열기 또는 내장 플레이어 호출
                            // URL: https://www.youtube.com/watch?v=\(v.key)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 16)
    }
}

struct SimilarSection: View {
    let list: [SimilarMovieEntity]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "비슷한 작품")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(list) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            if let posterUrl = item.posterURL {
                                KFImage(posterUrl)
                                    .resizable()
                                    .placeholder {
                                        Color.black.opacity(0.7)
                                        ProgressView()
                                    }
                                    .onFailure { error in
                                        print("이미지 로드 실패: \(error.localizedDescription)")
                                    }
                                    .scaledToFill()
                                    .frame(height: 260)
                                    .clipped()
                            }

                            Text(item.title)
                                .font(.caption)
                                .lineLimit(2)
                                .frame(width: 120, alignment: .leading)
                        }
                        .onTapGesture {
                            // 네비게이션: MovieDetailView(id: item.id)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 16)
    }
}
