//
//  MainTabPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI


struct MainTabPage: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.currentTab) {
            // HOME TAB
            NavigationStack(path: $coordinator.homePath) {
                HomePage()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(AppTab.home)
            // SEARCH TAB
            NavigationStack(path: $coordinator.searchPath) {
                SearchPage()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(AppTab.search)
            // WATCHLIST TAB
            NavigationStack(path: $coordinator.watchlistPath) {
                WatchlistPage()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .tabItem { Label("Watchlist", systemImage: "star") }
            .tag(AppTab.watchlist)
            // SETTINGS TAB
            NavigationStack(path: $coordinator.settingsPath) {
                SettingPage()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
            .tag(AppTab.settings)
        }
    }
}


#Preview {
    let store = AuthStore()
    let coordinator = AppCoordinator(authStore: store)
    return MainTabPage()
        .environmentObject(coordinator)
        .environmentObject(store)
}
