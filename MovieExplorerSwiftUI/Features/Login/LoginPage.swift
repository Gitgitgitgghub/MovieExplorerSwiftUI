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
    /// 全域提示/彈窗狀態（用於顯示錯誤對話框）
    @EnvironmentObject private var uiStore: AppUIStore
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
    /// 目前載入狀態（用於避免重複點擊與顯示全頁載入 overlay）
    @State private var loadingState: LoadingState = .idle
    /// 是否正在啟動外部授權流程（避免重複點擊，並顯示全頁載入 overlay）
    @State private var isLaunchingAuthorization: Bool = false

    // MARK: - Derived Values
    /// 是否正在處理登入/授權相關動作（用於顯示全頁載入 overlay）
    private var isBusy: Bool { loadingState.isLoading || isLaunchingAuthorization }

    /// 主按鈕是否不可點擊（避免重複送出，或帳密欄位未填）
    private var isPrimaryButtonDisabled: Bool {
        if isBusy { return true }
        switch loginMethod {
        case .webAuthorization:
            return false
        case .credentials:
            return username.isEmpty || password.isEmpty
        }
    }

    /// 主按鈕標題（依登入方式切換，不隨 loading 改變）
    private var primaryButtonTitle: String {
        switch loginMethod {
        case .webAuthorization:
            return "前往 TMDB 授權"
        case .credentials:
            return "使用帳密登入"
        }
    }

    // MARK: - View
    /// 登入頁主畫面
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .appBackground()
            .disabled(isBusy)
            .overlay { loadingOverlay }
            .onChange(of: loadingState) { _, newValue in
                if case let .failed(message) = newValue {
                    uiStore.showError(message)
                    loadingState = .idle
                }
            }
    }

    /// 全頁載入 overlay（涵蓋登入、訪客登入與啟動 web 授權）
    @ViewBuilder
    private var loadingOverlay: some View {
        if isBusy {
            ZStack {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                CinematicLoadingView(
                    title: loginMethod == .webAuthorization ? "正在啟動授權流程" : "登入中",
                    subtitle: loginMethod == .webAuthorization ? "即將跳轉到 TMDB 授權頁" : "正在建立 session，馬上就好"
                )
                .padding(.horizontal, 24)
            }
            .transition(.opacity)
        }
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
            loadingState = .idle
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
            Text("訪客登入")
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
            guard !isLaunchingAuthorization else { return }
            isLaunchingAuthorization = true
            defer { isLaunchingAuthorization = false }
            do {
                let authService = AuthService()
                let url = try await authService.authorizationURL()
                openURL(url)
            } catch {
                uiStore.showAlert(title: "授權啟動失敗", message: error.localizedDescription)
            }
        }
    }
    
    /// 以 TMDB 帳號密碼登入（在 UI 端檢查空值後交由 `AuthStore` 執行）
    private func loginWithCredentials() {
        Task { @MainActor in
            guard !loadingState.isLoading else { return }
            guard !username.isEmpty, !password.isEmpty else {
                uiStore.showError(username.isEmpty ? "請輸入 TMDB 使用者名稱" : "請輸入 TMDB 密碼")
                return
            }
            loadingState = .idle
            await withLoadingState(
                setState: { loadingState = $0 },
                successState: .idle
            ) {
                try await authStore.loginWithTMDBCredentials(username: username, password: password)
                password = ""
            }
        }
    }

    /// 開啟 TMDB 註冊頁（使用系統瀏覽器）
    private func openTMDBSignup() {
        guard let url = URL(string: tmdbSignupURLString) else {
            uiStore.showError("註冊頁網址不正確，請稍後再試")
            return
        }
        openURL(url)
    }

    /// 以訪客身分建立 session（不需帳號），成功後進入 App
    private func loginAsGuest() {
        Task { @MainActor in
            guard !loadingState.isLoading else { return }
            loadingState = .idle
            await withLoadingState(
                setState: { loadingState = $0 },
                successState: .idle
            ) {
                try await authStore.loginAsGuest()
            }
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
