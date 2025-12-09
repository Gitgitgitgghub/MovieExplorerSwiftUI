//
//  DateFormatter+Factory.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/09.
//

import Foundation

extension DateFormatter {
    static func make(format: String, locale: Locale) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter
    }
}
