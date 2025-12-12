//
//  StatCardsSectionView.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/11.
//

import SwiftUI

extension MovieDetailPage {
    
    struct StatCardsSectionView: View {
        
        var detail: MovieDetailResponse
        
        var body: some View {
            Grid {
                GridRow {
                    statTile(title: "評分", value: String(format: "%.1f", detail.voteAverage), icon: "star.fill")
                    statTile(title: "人氣", value: String(format: "%.0f", detail.popularity), icon: "flame.fill")
                    statTile(title: "票數", value: "\(detail.voteCount)", icon: "person.3.fill")
                }
                GridRow {
                    badge(text: detail.yearText.isEmpty ? "年份未定" : detail.yearText, icon: "calendar")
                    if let status = detail.status, !status.isEmpty {
                        badge(text: status, icon: "sparkles.tv")
                    }
                    if let runtime = detail.runtime {
                        badge(text: "\(runtime) 分鐘", icon: "clock")
                    }
                }
            }
            .padding(.horizontal)
        }
        
        private func badge(text: String, icon: String) -> some View {
            Label(text, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppColor.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .background(
                    LinearGradient(
                        colors: [AppColor.overlayStart.opacity(0.35), AppColor.overlayEnd.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: Capsule()
                )
                .overlay(
                    Capsule()
                        .stroke(AppColor.cardStroke.opacity(0.8), lineWidth: 1)
                )
        }

        private func statTile(title: String, value: String, icon: String) -> some View {
            VStack(alignment: .center, spacing: 8) {
                Label(title, systemImage: icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(AppColor.primaryText)
                Text(value)
                    .font(.title2.weight(.heavy))
                    .foregroundColor(AppColor.mutedText)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [AppColor.overlayStart.opacity(0.35), AppColor.overlayEnd.opacity(0.35)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColor.cardStroke.opacity(0.8), lineWidth: 1)
            )
        }
    }
    
}

#Preview {
    MovieDetailPage.StatCardsSectionView(detail: MovieDetailResponse.mock!)
}
