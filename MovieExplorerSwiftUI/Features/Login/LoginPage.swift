//
//  LoginPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/1.
//

import SwiftUI

struct LoginPage: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var authStore: AuthStore
    @Environment(\.openURL) private var openURL
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    /// 控制是否顯示保留的帳號密碼欄位（預設隱藏）
    private let showLegacyCredentials = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Welcome back")
                .font(.title)
                .bold()
                .foregroundColor(AppColor.mutedText)
            if showLegacyCredentials {
                legacyCredentialsForm
            }
            Button(action: {
                startTMDBAuthorization()
            }) {
                Text(isLoading ? "前往 TMDB 授權中..." : "前往 TMDB 授權")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColor.accent)
                    .clipShape(.capsule)
            }
            .padding(.init(top: 32, leading: 16, bottom: 0, trailing: 16))
            .disabled(isLoading)
            if showLegacyCredentials {
                divider
                    .padding(.top, 32)
                HStack(spacing: 32) {
                    Button(action: { }) {
                        Image(systemName: "apple.logo")
                            .frame(width: 60, height: 60)
                            .clipShape(.circle)
                            .glassEffect()
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "apple.logo")
                            .frame(width: 60, height: 60)
                            .clipShape(.circle)
                            .glassEffect()
                    }
                }
                .padding(.top, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appBackground()
        .padding(.top, 16)
        .overlay(alignment: .bottom) {
            if let message = (errorMessage ?? authStore.authErrorMessage) {
                Text(message)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(AppColor.surface)
                    .cornerRadius(12)
                    .padding(.bottom, 24)
            }
        }
    }
    
    private var legacyCredentialsForm: some View {
        Group {
            TextField(text: $email) {
                Text("Email")
                    .foregroundColor(AppColor.mutedText)
            }
            .padding()
            .background(AppColor.surface)
            .cornerRadius(10)
            .padding(.horizontal, 16)
            SecureField(text: $password) {
                Text("Password")
                    .foregroundColor(AppColor.mutedText)
            }
            .padding()
            .background(AppColor.surface)
            .cornerRadius(10)
            .padding(.horizontal, 16)
        }
        .accessibilityHidden(true)
    }

    private func startTMDBAuthorization() {
        Task { @MainActor in
            guard !isLoading else { return }
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            do {
                let authService = AuthService()
                let url = try await authService.authorizationURL()
                openURL(url)
            } catch {
                errorMessage = "授權啟動失敗：\(error.localizedDescription)"
                print("TMDB authorization failed: \(error)")
            }
        }
    }

    private var divider: some View {
        HStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(AppColor.mutedText)
            Text("Or continue with")
                .foregroundColor(AppColor.mutedText)
                .lineLimit(1)
                .padding(8)
                .layoutPriority(1)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(AppColor.mutedText)
        }
        .padding(.horizontal, 16)
    }
}
#Preview {
    let store = AuthStore()
    let coordinator = AppCoordinator(authStore: store)
    return LoginPage()
        .environmentObject(coordinator)
        .environmentObject(store)
}
