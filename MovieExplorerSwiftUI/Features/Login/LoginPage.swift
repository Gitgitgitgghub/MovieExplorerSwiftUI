//
//  LoginPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/1.
//

import SwiftUI

/// 登入頁：提供 TMDB 官方授權與帳密登入兩種方式，並顯示錯誤提示
struct LoginPage: View {
    
    /// 授權狀態與登入行為來源
    @EnvironmentObject private var authStore: AuthStore
    /// 由系統開啟外部授權網址
    @Environment(\.openURL) private var openURL

    // MARK: - Constants
    /// TMDB 註冊頁（引導使用者建立帳號）
    private let tmdbSignupURLString: String = "https://www.themoviedb.org/signup"

    // MARK: - Types
    /// 登入方式（官方授權 / 帳密登入）
    private enum LoginMethod: String, CaseIterable, Identifiable {
        /// 透過 TMDB 官方授權頁（redirect callback）
        case webAuthorization
        /// 以 TMDB 帳號密碼建立 session
        case credentials

        /// `ForEach` 穩定識別值
        var id: String { rawValue }

        /// UI 顯示用標題
        var title: String {
            switch self {
            case .webAuthorization: return "官方授權"
            case .credentials: return "帳密登入"
            }
        }
    }

    // MARK: - State
    /// TMDB 使用者名稱（非 email）
    @State private var username: String = ""
    /// TMDB 密碼（僅用於本次登入，不應持久化）
    @State private var password: String = ""
    /// 目前選擇的登入方式
    @State private var loginMethod: LoginMethod = .credentials
    /// 是否正在送出登入/授權請求（用於避免重複點擊）
    @State private var isLoading: Bool = false
    /// LoginPage 自身的錯誤訊息（優先顯示於 `AuthStore.authErrorMessage`）
    @State private var errorMessage: String?

    // MARK: - Derived Values
    /// 主按鈕是否不可點擊（避免重複送出，或帳密欄位未填）
    private var isPrimaryButtonDisabled: Bool {
        if isLoading { return true }
        switch loginMethod {
        case .webAuthorization:
            return false
        case .credentials:
            return username.isEmpty || password.isEmpty
        }
    }

    /// 主按鈕標題（依登入方式與 loading 狀態切換）
    private var primaryButtonTitle: String {
        switch loginMethod {
        case .webAuthorization:
            return isLoading ? "前往 TMDB 授權中..." : "前往 TMDB 授權"
        case .credentials:
            return isLoading ? "登入中..." : "使用帳密登入"
        }
    }
    
    // MARK: - View
    /// 登入頁主畫面
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .appBackground()
            .overlay(alignment: .bottom) { errorOverlay }
    }
    
    /// 登入頁內容區塊（不含背景與錯誤 overlay）
    private var content: some View {
        VStack(spacing: 12) {
            header
            loginMethodPicker
            credentialsSection
            primaryActionButton
            tmdbSignupButton
            divider
                .padding(.top, 32)
            guestLoginButton
                .padding(.top, 24)
        }
    }

    /// 標題區塊
    private var header: some View {
        Text("Welcome back")
            .font(.title)
            .bold()
            .foregroundColor(AppColor.mutedText)
    }

    /// 登入方式切換（官方授權 / 帳密登入）
    private var loginMethodPicker: some View {
        Picker("登入方式", selection: $loginMethod) {
            ForEach(LoginMethod.allCases) { method in
                Text(method.title).tag(method)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .onChange(of: loginMethod) { _, newValue in
            errorMessage = nil
            if newValue == .webAuthorization {
                password = ""
            }
        }
    }

    /// 帳密登入表單（僅在 `credentials` 模式顯示）
    @ViewBuilder
    private var credentialsSection: some View {
        if loginMethod == .credentials {
            UsernamePasswordForm(
                username: $username,
                password: $password
            )
        }
    }

    /// 主要動作按鈕（依登入方式切換：授權 / 登入）
    private var primaryActionButton: some View {
        let isDisabled = isPrimaryButtonDisabled
        return Button(action: handlePrimaryAction) {
            Text(primaryButtonTitle)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColor.primaryText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isDisabled ? AppColor.accent.opacity(0.35) : AppColor.accent)
                .clipShape(.capsule)
                .overlay {
                    Capsule()
                        .stroke(AppColor.cardStroke.opacity(isDisabled ? 0.25 : 0.5), lineWidth: 1)
                }
                .opacity(isDisabled ? 0.85 : 1)
        }
        .padding(.init(top: 32, leading: 16, bottom: 0, trailing: 16))
        .disabled(isPrimaryButtonDisabled)
    }

    /// 訪客登入（建立 guest session，允許進入 App 的受限功能）
    private var guestLoginButton: some View {
        Button(action: loginAsGuest) {
            Text(isLoading ? "處理中..." : "訪客登入")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColor.primaryText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColor.accent)
                .clipShape(.capsule)
                .overlay {
                    Capsule()
                        .stroke(AppColor.cardStroke.opacity(0.5), lineWidth: 1)
                }
        }
        .padding(.horizontal, 16)
        .disabled(isLoading)
    }

    /// 引導使用者前往 TMDB 註冊頁建立帳號
    private var tmdbSignupButton: some View {
        Button(action: openTMDBSignup) {
            Text("還沒有 TMDB 帳號？前往註冊")
                .font(.footnote)
                .foregroundColor(AppColor.mutedText)
                .underline()
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
        .disabled(isLoading)
    }

    /// 底部錯誤訊息 overlay（優先顯示 `errorMessage`，否則顯示 `AuthStore.authErrorMessage`）
    private var errorOverlay: some View {
        Group {
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

    // MARK: - Actions
    /// 依登入方式執行主要動作
    private func handlePrimaryAction() {
        switch loginMethod {
        case .webAuthorization:
            startTMDBAuthorization()
        case .credentials:
            loginWithCredentials()
        }
    }

    /// 啟動 TMDB 官方授權頁流程（取得 request token 並導向瀏覽器）
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
    
    /// 以 TMDB 帳號密碼登入（在 UI 端檢查空值後交由 `AuthStore` 執行）
    private func loginWithCredentials() {
        Task { @MainActor in
            guard !isLoading else { return }
            guard !username.isEmpty, !password.isEmpty else {
                if username.isEmpty {
                    errorMessage = "請輸入 TMDB 使用者名稱"
                } else {
                    errorMessage = "請輸入 TMDB 密碼"
                }
                return
            }
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            
            await authStore.loginWithTMDBCredentials(username: username, password: password)
            password = ""
        }
    }

    /// 開啟 TMDB 註冊頁（使用系統瀏覽器）
    private func openTMDBSignup() {
        guard let url = URL(string: tmdbSignupURLString) else {
            errorMessage = "註冊頁網址不正確，請稍後再試"
            return
        }
        openURL(url)
    }

    /// 以訪客身分建立 session（不需帳號），成功後進入 App
    private func loginAsGuest() {
        Task { @MainActor in
            guard !isLoading else { return }
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }

            await authStore.loginAsGuest()
        }
    }

    /// 分隔線區塊
    private var divider: some View {
        HStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(AppColor.mutedText)
            Text("或使用訪客登入")
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
    return LoginPage()
        .environmentObject(store)
}
