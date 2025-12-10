//
//  AppGradients.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/02.
//

import SwiftUI

enum AppGradients {
    /// 根據當前色彩方案返回對應的電影感背景。
    static func background(for colorScheme: ColorScheme) -> LinearGradient {
        switch colorScheme {
        case .dark:
            return darkCinematic
        default:
            return lightCinematic
        }
    }
    
    /// 深色模式的電影感背景。
    private static let darkCinematic = LinearGradient(
        colors: [
            Color(red: 0.09, green: 0.09, blue: 0.1),
            Color(red: 0.18, green: 0.18, blue: 0.2)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    /// 淺色模式的柔和霧白背景。
    private static let lightCinematic = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.89, green: 0.93, blue: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
