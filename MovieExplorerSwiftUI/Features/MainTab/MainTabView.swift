//
//  MainTabView.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI


struct MainTabView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.currentTab) {
            // HOME TAB
            NavigationStack(path: $coordinator.homePath) {
                HomeView()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(AppTab.home)
            // SEARCH TAB
            NavigationStack(path: $coordinator.searchPath) {
                SearchView()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(AppTab.search)
            // WATCHLIST TAB
            NavigationStack(path: $coordinator.watchlistPath) {
                WatchlistView()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .tabItem { Label("Watchlist", systemImage: "star") }
            .tag(AppTab.watchlist)
            // PROFILE TAB (optional)
            NavigationStack(path: $coordinator.profilePath) {
                ProfileView()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .tabItem { Label("Profile", systemImage: "person") }
            .tag(AppTab.profile)
        }
    }
}


#Preview {
    MainTabView()
        .environmentObject(AppCoordinator())
}
