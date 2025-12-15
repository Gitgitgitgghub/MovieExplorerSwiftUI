//
//  DateFormatter+Factory.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/09.
//

import Foundation

extension DateFormatter {
    /// 建立指定格式的 `DateFormatter`
    /// - Parameters:
    ///   - format: 日期格式字串
    ///   - locale: 使用的 locale（建議解析固定格式時用 `en_US_POSIX`）
    ///   - timeZone: 解析/顯示用時區；為 nil 時沿用系統預設
    /// - Returns: 設定完成的 `DateFormatter`
    static func make(format: String, locale: Locale, timeZone: TimeZone? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        formatter.timeZone = timeZone
        return formatter
    }

    /// TMDB `expires_at` 欄位的 UTC 解析 formatter（例如：`2025-12-31 23:59:59 UTC`）
    static let tmdbExpiresAtUTC: DateFormatter = .make(
        format: "yyyy-MM-dd HH:mm:ss 'UTC'",
        locale: Locale(identifier: "en_US_POSIX"),
        timeZone: TimeZone(secondsFromGMT: 0)
    )
}
