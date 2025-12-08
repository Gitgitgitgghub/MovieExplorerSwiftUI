//
//  CinematicLoadingView.swift
//  MovieExplorerSwiftUI
//
//  Created by GPT on 2025/12/05.
//

import SwiftUI

/// 具電影氛圍感的載入元件，可覆蓋在任何列表或頁面上。
/// 會顯示旋轉的底片輪盤、柔和漸層光暈與進度脈動條，三者同時動畫讓等待更有感。
struct CinematicLoadingView: View {

    var title: String = "正在載入精彩片單"
    var subtitle: String = "為你挑選最新的話題電影，馬上就好"
    private let reelSize: CGFloat = 120
    private let containerCornerRadius: CGFloat = 28
    private let containerPadding: CGFloat = 32
    private let progressHeight: CGFloat = 14

    @State private var isSpinning = false
    @State private var isPulsing = false
    @State private var progress: CGFloat = 0.25

    var body: some View {
        VStack(spacing: 28) {
            reel(size: reelSize)
                .frame(width: reelSize, height: reelSize)
                .rotationEffect(.degrees(isSpinning ? 360 : 0))
                .animation(.linear(duration: 6).repeatForever(autoreverses: false), value: isSpinning)
                .scaleEffect(isPulsing ? 1.04 : 0.96)
                .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: isPulsing)

            VStack(spacing: 6) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(AppColor.primaryText)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(AppColor.secondaryText)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                    .lineLimit(3)
            }
            .padding(.horizontal, 16)

            ProgressGlow(progress: progress)
                .frame(height: progressHeight)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                        progress = 1
                    }
                }
        }
        .padding(containerPadding)
        .frame(width: 300, height: 300)
        .glassEffect(in: RoundedRectangle(cornerRadius: containerCornerRadius, style: .continuous))
        .shadow(color: AppColor.shadow.opacity(0.4), radius: reelSize * 0.17, x: 0, y: reelSize * 0.11)
        .onAppear {
            isSpinning = true
            isPulsing = true
        }
    }

    private func reel(size: CGFloat) -> some View {
        // Scale child metrics relative to base size 180 for consistent proportions.
        let scale = size / 180

        return ZStack {
            Circle()
                .fill(AngularGradient(
                    gradient: Gradient(colors: [
                        AppColor.overlayStart.opacity(0.9),
                        AppColor.overlayEnd.opacity(0.9),
                        AppColor.overlayStart.opacity(0.9)
                    ]),
                    center: .center
                ))
                .blur(radius: 15 * scale)
                .opacity(0.45)

            Circle()
                .stroke(AppColor.cardStroke.opacity(0.4), lineWidth: 3 * scale)

            Circle()
                .strokeBorder(
                    LinearGradient(
                        colors: [AppColor.accent.opacity(0.9), AppColor.overlayEnd.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 8 * scale
                )
                .shadow(color: AppColor.shadow.opacity(0.6), radius: 20 * scale, x: 0, y: 10 * scale)

            ForEach(0..<6) { index in
                Capsule()
                    .fill(AppColor.onMediaPrimary.opacity(0.65))
                    .frame(width: 14 * scale, height: 32 * scale)
                    .offset(y: -(size * 0.455))
                    .rotationEffect(.degrees(Double(index) / 6 * 360))
            }

            Circle()
                .fill(
                    LinearGradient(
                        colors: [AppColor.surface.opacity(0.8), Color.black.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 70 * scale, height: 70 * scale)
                .overlay {
                    Circle()
                        .stroke(AppColor.cardStroke.opacity(0.5), lineWidth: 2 * scale)
                }

            ForEach(0..<8) { index in
                Circle()
                    .fill(AppColor.overlayStart.opacity(0.9))
                    .frame(width: 12 * scale, height: 12 * scale)
                    .offset(y: -(size * 0.267))
                    .rotationEffect(.degrees(Double(index) / 8 * 360))
            }
        }
    }
}

private struct ProgressGlow: View {
    var progress: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let width = max(proxy.size.width * 0.2, proxy.size.width * min(progress, 1))

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 999, style: .continuous)
                    .fill(AppColor.surface.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: 999, style: .continuous)
                            .stroke(AppColor.cardStroke.opacity(0.2), lineWidth: 1)
                    )

                RoundedRectangle(cornerRadius: 999, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [AppColor.accent, AppColor.overlayEnd],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: width)
                    .shadow(color: AppColor.accent.opacity(0.8), radius: 18, x: 0, y: 0)
                    .overlay(alignment: .trailing) {
                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 12, height: 12)
                            .shadow(color: Color.white.opacity(0.7), radius: 8)
                    }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.9)
        CinematicLoadingView()
            .padding(24)
            .frame(width: 300, height: 300)
    }
    .ignoresSafeArea()
    .preferredColorScheme(.dark)
}
