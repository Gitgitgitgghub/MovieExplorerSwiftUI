//
//  GenresSectionView.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/11.
//

import SwiftUI

extension MovieDetailPage {
    
    struct GenresSectionView: View {
        
        var detail: MovieDetailResponse
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                SectionTitleView(text: "類型")
                if detail.genres.isEmpty {
                    Text("暫無類型資訊")
                        .font(.subheadline)
                        .foregroundColor(AppColor.secondaryText)
                } else {
                    ChipFlow(horizontalSpacing: 8, verticalSpacing: 8) {
                        ForEach(detail.genres, id: \.id) { genre in
                            Text(genre.name)
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(AppColor.primaryText)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
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
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
}


#Preview {
    MovieDetailPage.GenresSectionView(detail: MovieDetailResponse.mock!)
}
