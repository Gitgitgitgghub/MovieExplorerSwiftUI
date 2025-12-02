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
    case profile
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

    // MARK: - Navigation Paths (One per tab)
    @Published var homePath = NavigationPath()
    @Published var searchPath = NavigationPath()
    @Published var watchlistPath = NavigationPath()
    @Published var profilePath = NavigationPath()

    // MARK: - Push a route
    func push(_ route: AppRoute) {
        switch currentTab {
        case .home:
            homePath.append(route)
        case .search:
            searchPath.append(route)
        case .watchlist:
            watchlistPath.append(route)
        case .profile:
            profilePath.append(route)
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
        case .profile:
            profilePath.append(route)
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
        case .profile:
            if !profilePath.isEmpty { profilePath.removeLast() }
        }
    }

    // MARK: - Pop to root of current tab
    func popToRoot() {
        switch currentTab {
        case .home: homePath = NavigationPath()
        case .search: searchPath = NavigationPath()
        case .watchlist: watchlistPath = NavigationPath()
        case .profile: profilePath = NavigationPath()
        }
    }

    // MARK: - Build Destination for NavigationStack
    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {
        case .movieDetail(let id):
            MovieDetailView(movieID: id)
        case .actorDetail(let id):
            ActorDetailView(actorID: id)
        case .search:
            SearchView()
        case .watchlist:
            WatchlistView()
        }
    }
}
