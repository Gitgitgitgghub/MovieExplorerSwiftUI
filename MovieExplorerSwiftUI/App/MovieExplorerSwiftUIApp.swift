//
//  MovieExplorerSwiftUIApp.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/26.
//

import SwiftUI

@main
struct MovieExplorerSwiftUIApp: App {

    /// App 前景/背景狀態（用於在回到前景時檢查訪客 session 是否過期）
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var authStore: AuthStore
    @StateObject private var coordinator: AppCoordinator

    init() {
        _authStore = StateObject(wrappedValue: AuthStore())
        _coordinator = StateObject(wrappedValue: AppCoordinator())
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
                    await authStore.handleAuthCallback(url: url)
                }
            }
            .onChange(of: scenePhase) { _, newValue in
                guard newValue == .active else { return }
                authStore.invalidateGuestSessionIfExpired()
            }
        }
    }
}
