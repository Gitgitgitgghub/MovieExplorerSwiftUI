//
//  CinematicErrorView.swift
//  MovieExplorerSwiftUI
//
//  Created by GPT on 2025/12/05.
//

import SwiftUI

/// 與載入動畫同風格的錯誤提示，以 Alert 尺寸呈現，附帶重試按鈕。
struct CinematicErrorView: View {

    var title: String = "載入失敗"
    var message: String = "暫時無法取得片單，請稍後再試"
    var retryTitle: String = "重新整理"
    var onRetry: (() -> Void)?

    private let iconSize: CGFloat = 96
    private let cornerRadius: CGFloat = 28
    private let padding: CGFloat = 32
    @State private var isGlowing = false
    @State private var isWiggling = false

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColor.overlayStart.opacity(0.85),
                                AppColor.overlayEnd.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: iconSize * 1.15, height: iconSize * 1.15)
                    .blur(radius: 16)
                    .opacity(0.8)

                // 扭曲的膠卷與警示閃電，讓錯誤提示更有電影感
                FilmWarningIcon(size: iconSize, isPulsing: isGlowing)
                    .scaleEffect(isGlowing ? 1.04 : 0.96)
                    .rotationEffect(.degrees(isWiggling ? 5 : -5))
            }
            .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: isGlowing)
            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: isWiggling)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundColor(AppColor.primaryText)

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(AppColor.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.85)
                    .padding(.horizontal, 12)
            }

            Button(action: { onRetry?() }) {
                Text(retryTitle)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(AppColor.onMediaPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [AppColor.overlayStart, AppColor.overlayEnd],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: Capsule()
                    )
                    .shadow(color: AppColor.shadow.opacity(0.5), radius: 12, x: 0, y: 6)
            }
            .padding(.top, 8)
        }
        .padding(padding)
        .frame(minWidth: 260, maxWidth: 360, alignment: .center)
        .glassEffect(in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: AppColor.shadow.opacity(0.4), radius: 24, x: 0, y: 14)
        .onAppear {
            isGlowing = true
            isWiggling = true
        }
    }
}

/// 帶警告脈衝的膠卷錯誤圖示（以破損底片帶取代閃電）。
private struct FilmWarningIcon: View {
    let size: CGFloat
    let isPulsing: Bool

    var body: some View {
        let reelSize = size * 0.9
        let badgeSize = size * 0.42

        ZStack {
            // 外圈警告脈衝（改為紅調）
            Circle()
                .stroke(Color.rgb(244, 92, 92).opacity(isPulsing ? 0.7 : 0.35), lineWidth: size * 0.08)
                .frame(width: reelSize * 1.1, height: reelSize * 1.1)
                .scaleEffect(isPulsing ? 1.12 : 0.96)
                .blur(radius: 1.5)
                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: isPulsing)

            // 外圈膠卷
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [AppColor.overlayStart.opacity(0.9), AppColor.overlayEnd.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: size * 0.12
                )
                .frame(width: reelSize, height: reelSize)
                .shadow(color: AppColor.shadow.opacity(0.6), radius: 12, x: 0, y: 8)

            // 膠卷孔
            ForEach(0..<6) { index in
                Capsule()
                    .fill(AppColor.onMediaPrimary.opacity(0.8))
                    .frame(width: size * 0.1, height: size * 0.22)
                    .offset(y: -(reelSize / 2.1))
                    .rotationEffect(.degrees(Double(index) / 6 * 360))
            }

            // 內圈
            Circle()
                .fill(
                    LinearGradient(
                        colors: [AppColor.surface.opacity(0.9), AppColor.overlayEnd.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: reelSize * 0.55, height: reelSize * 0.55)
                .overlay {
                    Circle()
                        .stroke(AppColor.cardStroke.opacity(0.6), lineWidth: size * 0.025)
                }

            // 驚嘆號徽章（取代閃電）
            ZStack {
                VStack(spacing: badgeSize * 0.12) {
                    Capsule()
                        .fill(Color.rgb(255, 140, 120))
                        .frame(width: badgeSize * 0.16, height: badgeSize * 0.5)
                    Circle()
                        .fill(Color.rgb(255, 140, 120))
                        .frame(width: badgeSize * 0.16, height: badgeSize * 0.16)
                }
            }
            .rotationEffect(.degrees(-6))
        }
    }
}


#Preview {
    ZStack {
        Color.black.opacity(0.85).ignoresSafeArea()
        CinematicErrorView(onRetry: {})
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    .preferredColorScheme(.dark)
}
