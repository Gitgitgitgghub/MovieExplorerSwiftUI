//
//  GlassAlertOverlay.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/17.
//

import SwiftUI

/// 以 Liquid Glass 風格呈現的全域提示 overlay（替代系統 `.alert`，可自訂外觀）。
struct GlassAlertOverlay: View {

    /// 目前要顯示的提示（nil 表示不顯示）
    @Binding var alert: AppUIStore.Alert?

    var body: some View {
        if let alert {
            ZStack {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }

                VStack(spacing: 12) {
                    Text(alert.title)
                        .font(.headline)
                        .foregroundColor(AppColor.primaryText)
                        .multilineTextAlignment(.center)

                    Text(alert.message)
                        .font(.subheadline)
                        .foregroundColor(AppColor.secondaryText)
                        .multilineTextAlignment(.center)
                    Button {
                        dismiss()
                    } label: {
                        Text("確定")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AppColor.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppColor.accent)
                        .clipShape(Capsule())
                        .padding(.top, 6)
                    }
                }
                .padding(24)
                .frame(maxWidth: 340)
                .glassEffect(in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppColor.cardStroke.opacity(0.22), lineWidth: 1)
                }
                .shadow(color: AppColor.shadow.opacity(0.35), radius: 16, x: 0, y: 10)
                .padding(.horizontal, 24)
            }
            .transition(.opacity)
        }
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.2)) {
            alert = nil
        }
    }
}

#Preview {
    GlassAlertOverlay(alert: .constant(.init(title: "Hello", message: "This is a test")))
}
