//
//  MovieExplorerSwiftUIApp.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/26.
//

import SwiftUI

@main
struct MovieExplorerSwiftUIApp: App {

    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            Group {
                if coordinator.isAuthenticated {
                    MainTabPage()
                } else {
                    LoginPage()
                }
            }
            .environmentObject(coordinator)
            .preferredColorScheme(coordinator.theme.colorScheme)
            .animation(.easeInOut, value: coordinator.isAuthenticated)
        }
    }
}
