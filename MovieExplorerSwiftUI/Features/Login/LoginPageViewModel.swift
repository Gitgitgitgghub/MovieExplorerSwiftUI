//
//  LoginPageViewModel.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/02.
//

import SwiftUI

@MainActor
final class LoginPageViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    var subtitleText: String { "Sign in to continue" }

    nonisolated init() {}

    func login(using coordinator: AppCoordinator) {
        Task {
            do {
                try await loadTMDBConfiuration()
                coordinator.currentTab = .home
                coordinator.isAuthenticated = true
                print("Login successful")
            }
        }
    }
    
    private func loadTMDBConfiuration() async throws {
        try await TMDBConfigurationLoader.shared.loadIfNeeded()
    }
        
}
