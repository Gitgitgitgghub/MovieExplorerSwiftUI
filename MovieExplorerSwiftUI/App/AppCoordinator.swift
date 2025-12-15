//
//  AppCoordinator.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//


import SwiftUI

// MARK: - App Tabs
/// App 主分頁識別值（對應 `TabView` 的 selection）
enum AppTab: Hashable {
    /// 首頁
    case home
    /// 搜尋
    case search
    /// 片單/收藏
    case watchlist
    /// 設定
    case settings
}

// MARK: - Global Route
/// App 全域路由（用於各 tab 的 `NavigationStack`）
enum AppRoute: Hashable {
    /// 電影詳情頁
    case movieDetail(id: Int)
    /// 演員詳情頁
    case actorDetail(id: Int)
    /// 搜尋頁
    case search
    /// 片單/收藏頁
    case watchlist
}

/// 導航協調器：管理 Tab 與各分頁的 NavigationPath
final class AppCoordinator: ObservableObject {

    /// 當前分頁
    @Published var currentTab: AppTab = .home
    /// App 主題（影響 `preferredColorScheme`）
    @Published var theme: AppTheme = .system
    
    /// 建立 `AppCoordinator`（不負責授權狀態）
    init() {}

    // MARK: - Navigation Paths (One per tab)
    /// Home tab 導航路徑
    @Published var homePath = NavigationPath()
    /// Search tab 導航路徑
    @Published var searchPath = NavigationPath()
    /// Watchlist tab 導航路徑
    @Published var watchlistPath = NavigationPath()
    /// Settings tab 導航路徑
    @Published var settingsPath = NavigationPath()

    // MARK: - Push a route
    /// 將路由推入目前所在 tab 的路徑
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
    /// 切換到指定 tab 並推入路由
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
    /// 彈出目前 tab 的上一層路由（若已在 root 則不動作）
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
    /// 清空目前 tab 的路徑，回到 root
    func popToRoot() {
        switch currentTab {
        case .home: homePath = NavigationPath()
        case .search: searchPath = NavigationPath()
        case .watchlist: watchlistPath = NavigationPath()
        case .settings: settingsPath = NavigationPath()
        }
    }

    // MARK: - Build Destination for NavigationStack
    /// 由路由建立對應的目的地頁面
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
    
    /// 取得目前 tab 的 NavigationPath（用於除錯或特殊導航需求）
    func currentPath() -> NavigationPath {
        switch currentTab {
        case .home: homePath
        case .search: searchPath
        case .watchlist: watchlistPath
        case .settings: settingsPath
        }
    }
}

/// App 主題設定（系統/淺色/深色）
enum AppTheme: String, CaseIterable, Identifiable {
    /// 依系統自動切換
    case system
    /// 強制淺色
    case light
    /// 強制深色
    case dark
    
    /// `Picker` 使用的識別值
    var id: String { rawValue }
    
    /// UI 顯示標題
    var title: String {
        switch self {
        case .system: return "系統"
        case .light: return "淺色"
        case .dark: return "深色"
        }
    }
    
    /// UI 顯示說明
    var description: String {
        switch self {
        case .system: return "依照系統設定自動切換。"
        case .light: return "強制使用明亮背景與高對比文字。"
        case .dark: return "以影院感深色主題呈現。"
        }
    }
    
    /// 對應的 `ColorScheme`（system 會回傳 nil）
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
