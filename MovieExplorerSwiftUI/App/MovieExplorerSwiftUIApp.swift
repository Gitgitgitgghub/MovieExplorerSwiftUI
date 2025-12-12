//
//  MovieExplorerSwiftUIApp.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/26.
//

import SwiftUI

@main
struct MovieExplorerSwiftUIApp: App {

    @StateObject private var authStore = AuthStore()
    @StateObject private var coordinator: AppCoordinator

    init() {
        let store = AuthStore()
        _authStore = StateObject(wrappedValue: store)
        _coordinator = StateObject(wrappedValue: AppCoordinator(authStore: store))
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if authStore.isAuthenticated {
                    MainTabPage()
                } else {
                    LoginPage()
                }
            }
            .environmentObject(coordinator)
            .environmentObject(authStore)
            .preferredColorScheme(coordinator.theme.colorScheme)
            .animation(.easeInOut, value: authStore.isAuthenticated)
            .onOpenURL { url in
                Task {
                    await coordinator.handleAuthCallback(url: url)
                }
            }
        }
    }
}
