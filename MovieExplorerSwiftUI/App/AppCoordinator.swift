//
//  AppCoordinator.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//


import SwiftUI

// MARK: - App Tabs
enum AppTab: Hashable {
    case home
    case search
    case watchlist
    case settings
}

// MARK: - Global Route
enum AppRoute: Hashable {
    case movieDetail(id: Int)
    case actorDetail(id: Int)
    case search
    case watchlist
}

final class AppCoordinator: ObservableObject {

    @Published var isAuthenticated: Bool = false
    @Published var currentTab: AppTab = .home
    @Published var theme: AppTheme = .system

    // MARK: - Navigation Paths (One per tab)
    @Published var homePath = NavigationPath()
    @Published var searchPath = NavigationPath()
    @Published var watchlistPath = NavigationPath()
    @Published var settingsPath = NavigationPath()

    // MARK: - Push a route
    func push(_ route: AppRoute) {
        switch currentTab {
        case .home:
            homePath.append(route)
        case .search:
            searchPath.append(route)
        case .watchlist:
            watchlistPath.append(route)
        case .settings:
            settingsPath.append(route)
        }
    }

    // MARK: - Push to specific tab (cross-tab)
    func push(_ route: AppRoute, to tab: AppTab) {
        currentTab = tab
        switch tab {
        case .home:
            homePath.append(route)
        case .search:
            searchPath.append(route)
        case .watchlist:
            watchlistPath.append(route)
        case .settings:
            settingsPath.append(route)
        }
    }

    // MARK: - Pop current tab
    func pop() {
        switch currentTab {
        case .home:
            if !homePath.isEmpty { homePath.removeLast() }
        case .search:
            if !searchPath.isEmpty { searchPath.removeLast() }
        case .watchlist:
            if !watchlistPath.isEmpty { watchlistPath.removeLast() }
        case .settings:
            if !settingsPath.isEmpty { settingsPath.removeLast() }
        }
    }

    // MARK: - Pop to root of current tab
    func popToRoot() {
        switch currentTab {
        case .home: homePath = NavigationPath()
        case .search: searchPath = NavigationPath()
        case .watchlist: watchlistPath = NavigationPath()
        case .settings: settingsPath = NavigationPath()
        }
    }

    // MARK: - Build Destination for NavigationStack
    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {
        case .movieDetail(let id):
            MovieDetailPage(movieID: id)
        case .actorDetail(let id):
            ActorDetailPage(actorID: id)
        case .search:
            SearchPage()
        case .watchlist:
            WatchlistPage()
        }
    }
}

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .system: return "系統"
        case .light: return "淺色"
        case .dark: return "深色"
        }
    }
    
    var description: String {
        switch self {
        case .system: return "依照系統設定自動切換。"
        case .light: return "強制使用明亮背景與高對比文字。"
        case .dark: return "以影院感深色主題呈現。"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
