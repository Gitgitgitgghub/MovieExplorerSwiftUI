//
//  PosterCard.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/9.
//

import SwiftUI


struct PosterCard: View {
    let url: URL?
    @State private var reloadID = UUID()
    
    var body: some View {
        ZStack {
            placeholderBackground
            if let url = url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                    case .failure:
                        failurePlaceholder
                    case .empty:
                        Color.clear
                    @unknown default:
                        Color.clear
                    }
                }
                .id(reloadID)
            } else {
                failurePlaceholder
                    .id(reloadID)
            }
        }
    }
    
    private var placeholderBackground: some View {
        LinearGradient(
            colors: [Color(.systemGray5), Color(.systemGray4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var failurePlaceholder: some View {
        VStack(spacing: 6) {
            Image(systemName: "film")
                .font(.headline.weight(.bold))
                .foregroundColor(AppColor.accent)
            Text("無法載入圖片")
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColor.primaryText)
            Button(action: reloadImage) {
                Label("重新載入", systemImage: "arrow.clockwise")
                    .foregroundColor(AppColor.mutedText)
                    .font(.caption.weight(.bold))
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColor.surface, in: Capsule())
            }
            .padding(.top, 12)
        }
    }
    
    private func reloadImage() {
        reloadID = UUID()
    }
}


#Preview {
    PosterCard(url: nil)
        .frame(width: 120, height: 180)
    
}
