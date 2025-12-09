//
//  View+AppBackground.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/02.
//

import SwiftUI

extension View {
    func appBackground() -> some View {
        modifier(AppBackgroundModifier())
    }
}

private struct AppBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content.background {
            AppGradients.background(for: colorScheme)
                .ignoresSafeArea()
        }
    }
}
