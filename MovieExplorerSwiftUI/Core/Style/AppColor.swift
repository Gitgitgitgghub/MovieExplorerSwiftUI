//
//  AppColor.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/03.
//

import SwiftUI

enum AppColor {
    /// 一般情境主要文字色。
    static let primaryText = Color("PrimaryText")
    /// 輔助說明或次要資訊文字色。
    static let secondaryText = Color("SecondaryText")
    /// 再次要、提示或 Meta 資訊文字色。
    static let tertiaryText = Color("TertiaryText")
    /// 次要文字／提示用色，維持足夠對比但不搶主視覺。
    static let mutedText = Color("MutedText")
    /// 元件背景提示色，例如輸入框或卡片的填色。
    static let surface = Color("Surface")
    /// 品牌重點色，用於主動作按鈕或強調訊息。
    static let accent = Color("Accent")
    /// 卡片描邊或分隔線用色。
    static let cardStroke = Color("CardStroke")
    /// 徽章、Tag 等小面積背景色。
    static let badgeBackground = Color("BadgeBackground")
    /// Media（海報、橫幅）上可讀文字色。
    static let onMediaPrimary = Color("OnMediaPrimary")
    /// Media 上次要文字色。
    static let onMediaSecondary = Color("OnMediaSecondary")
    /// Media 漸層遮罩的起始色。
    static let overlayStart = Color("OverlayStart")
    /// Media 漸層遮罩的結束色。
    static let overlayEnd = Color("OverlayEnd")
    /// 卡片或海報陰影色。
    static let shadow = Color("Shadow")
}
