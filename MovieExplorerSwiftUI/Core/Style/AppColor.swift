//
//  AppColor.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/03.
//

import SwiftUI

enum AppColor {
    /// 依據介面明暗模式回傳對應的系統色組。
    struct Palette {
        /// 一般情境主要文字色。
        let primaryText: Color
        /// 輔助說明或次要資訊文字色。
        let secondaryText: Color
        /// 再次要、提示或 Meta 資訊文字色。
        let tertiaryText: Color
        /// 次要文字／提示用色，維持足夠對比但不搶主視覺。
        let mutedText: Color
        /// 元件背景提示色，例如輸入框或卡片的填色。
        let surface: Color
        /// 品牌重點色，用於主動作按鈕或強調訊息。
        let accent: Color
        /// 卡片描邊或分隔線用色。
        let cardStroke: Color
        /// 徽章、Tag 等小面積背景色。
        let badgeBackground: Color
        /// Media（海報、橫幅）上可讀文字色。
        let onMediaPrimary: Color
        /// Media 上次要文字色。
        let onMediaSecondary: Color
        /// Media 漸層遮罩的起始色。
        let overlayStart: Color
        /// Media 漸層遮罩的結束色。
        let overlayEnd: Color
        /// 卡片或海報陰影色。
        let shadow: Color
    }
    
    static func palette(for colorScheme: ColorScheme) -> Palette {
        switch colorScheme {
        case .dark:
            return Palette(
                primaryText: .white,
                secondaryText: .white.opacity(0.85),
                tertiaryText: .white.opacity(0.75),
                mutedText: Color.rgb(145, 163, 199),
                surface: Color.rgb(35, 46, 72),
                accent: Color.rgb(74, 144, 226),
                cardStroke: Color.white.opacity(0.08),
                badgeBackground: Color.white.opacity(0.12),
                onMediaPrimary: .white,
                onMediaSecondary: .white.opacity(0.85),
                overlayStart: .black.opacity(0.85),
                overlayEnd: .black.opacity(0.01),
                shadow: .black.opacity(0.25)
            )
        default:
            return Palette(
                primaryText: Color.rgb(18, 26, 43),
                secondaryText: Color.rgb(80, 95, 120),
                tertiaryText: Color.rgb(125, 138, 160),
                mutedText: Color.rgb(64, 78, 110),
                surface: Color.rgb(244, 246, 255),
                accent: Color.rgb(51, 102, 204),
                cardStroke: Color.black.opacity(0.05),
                badgeBackground: Color.black.opacity(0.08),
                onMediaPrimary: .white,
                onMediaSecondary: .white.opacity(0.9),
                overlayStart: .black.opacity(0.55),
                overlayEnd: .black.opacity(0.01),
                shadow: .black.opacity(0.15)
            )
        }
    }
}
