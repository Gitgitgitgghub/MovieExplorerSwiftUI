//
//  CastSectionView.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/11.
//

import SwiftUI

extension MovieDetailPage {
    
    struct CastSectionView: View {
        
        var credits: CreditsResponse?
        var tap: ((Int) -> Void)?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                if let casts = credits?.cast, !casts.isEmpty {
                    SectionTitleView(text: "主要卡司")
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(casts) { cast in
                                CastCard(cast: cast)
                                    .onTapGesture {
                                        tap?(cast.id)
                                    }
                            }
                        }
                    }
                } else {
                    Text("暫無演員資訊")
                        .font(.subheadline)
                        .foregroundColor(AppColor.secondaryText)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private struct CastCard: View {
        let cast: Cast

        var body: some View {
            VStack(alignment: .center, spacing: 10) {
                PosterCard(url: cast.profileURL)
                .frame(width: 110, height: 140)
                .background(placeholder)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppColor.cardStroke, lineWidth: 1)
                )

                VStack(spacing: 4) {
                    Text(cast.name)
                        .font(.subheadline.weight(.bold))
                        .minimumScaleFactor(0.8)
                        .foregroundColor(AppColor.primaryText)
                        .lineLimit(1)
                    Text(cast.displayCharacter.isEmpty ? "演員" : cast.displayCharacter)
                        .font(.caption)
                        .foregroundColor(AppColor.secondaryText)
                        .lineLimit(1)
                }
                .padding(.horizontal, 2)
                .frame(width: 120)
            }
        }

        private var placeholder: some View {
            LinearGradient(
                colors: [Color(.systemGray5), Color(.systemGray4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                Image(systemName: "person.crop.rectangle")
                    .font(.title2.weight(.bold))
                    .foregroundColor(AppColor.secondaryText)
            )
        }
    }
}

#Preview {
    MovieDetailPage.CastSectionView(credits: CreditsResponse.mock!)
}
