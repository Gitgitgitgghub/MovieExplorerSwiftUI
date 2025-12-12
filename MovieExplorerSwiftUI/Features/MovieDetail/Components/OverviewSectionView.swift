//
//  OverviewSectionView.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/11.
//

import SwiftUI

extension MovieDetailPage {
    struct OverviewSectionView: View {
        
        @State var isOverviewExpanded: Bool = false
        var detail: MovieDetailResponse
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    Text(detail.title)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppColor.primaryText)
                        
                    Image(systemName: "chevron.down")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(AppColor.secondaryText)
                        .rotationEffect(.degrees(isOverviewExpanded ? 180 : 0))
                    Spacer()
                }
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                        isOverviewExpanded.toggle()
                    }
                }
                if isOverviewExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        if let tagline = detail.tagline, !tagline.isEmpty {
                            Text(tagline)
                                .font(.headline.weight(.semibold))
                                .foregroundColor(AppColor.secondaryText)
                        }
                        SectionTitleView(text: "劇情簡介")
                        Text(detail.overview.isEmpty ? "暫無劇情簡介" : detail.overview)
                            .font(.body)
                            .foregroundColor(AppColor.secondaryText)
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                    }
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95, anchor: .top)),
                        removal: .opacity.combined(with: .scale(scale: 0.95, anchor: .top))
                    ))
                }
            }
            .padding(.horizontal)
        }
    }
    
}

#Preview {
    MovieDetailPage.OverviewSectionView(detail: MovieDetailResponse.mock!)
}


