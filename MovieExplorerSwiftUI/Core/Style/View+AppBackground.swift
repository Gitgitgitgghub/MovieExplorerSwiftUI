//
//  View+AppBackground.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/02.
//

import SwiftUI

extension View {
    func appBackground() -> some View {
        background {
            AppGradients.cinematic
                .ignoresSafeArea()
        }
    }
}
