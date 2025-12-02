//
//  Color+RGB.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/02.
//

import SwiftUI

extension Color {
    
    /// Convenience helper to create a color from 0-255 RGB values.
    static func rgb(_ red: Double, _ green: Double, _ blue: Double, opacity: Double = 1) -> Color {
        Color(
            red: red.clampedToRGB(),
            green: green.clampedToRGB(),
            blue: blue.clampedToRGB(),
            opacity: opacity
        )
    }
    
    /// Convenience helper to create a color from integer RGB values.
    static func rgb(_ red: Int, _ green: Int, _ blue: Int, opacity: Double = 1) -> Color {
        rgb(Double(red), Double(green), Double(blue), opacity: opacity)
    }
}

private extension Double {
    func clampedToRGB() -> Double {
        min(max(self / 255, 0), 1)
    }
}
