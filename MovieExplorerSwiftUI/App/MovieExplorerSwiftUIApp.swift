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
    /// App 全域提示/彈窗狀態
    @StateObject private var uiStore: AppUIStore

    init() {
        _authStore = StateObject(wrappedValue: AuthStore())
        _coordinator = StateObject(wrappedValue: AppCoordinator())
        _uiStore = StateObject(wrappedValue: AppUIStore())
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
            .environmentObject(uiStore)
            .preferredColorScheme(coordinator.theme.colorScheme)
            .animation(.easeInOut, value: authStore.isAuthenticated)
            .overlay { GlassAlertOverlay(alert: $uiStore.alert) }
            .onOpenURL { url in
                Task {
                    do {
                        try await authStore.handleAuthCallback(url: url)
                    } catch {
                        await MainActor.run { uiStore.showAlert(title: "授權失敗", message: error.localizedDescription) }
                    }
                }
            }
            .onChange(of: scenePhase) { _, newValue in
                guard newValue == .active else { return }
                authStore.invalidateGuestSessionIfExpired()
            }
        }
    }
}
