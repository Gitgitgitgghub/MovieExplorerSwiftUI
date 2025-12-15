//
//  AuthStore.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/13.
//

import Foundation

/// 管理 TMDB 授權狀態的 Store
@MainActor
final class AuthStore: ObservableObject {
    
    /// 授權流程服務（負責解析回呼與交換 session）
    private let authService: AuthService
    
    /// 當前使用者身分（登入/訪客/匿名）
    @Published var identity: AuthIdentity = .anonymous
    /// 授權相關錯誤訊息（顯示於 UI）
    @Published var authErrorMessage: String?
    
    /// 建立 `AuthStore`，可注入測試用的 `AuthService`
    /// - Parameter authService: 授權流程服務（預設使用真實 `AuthService`）
    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    /// 以登入結果更新為 loggedIn 狀態
    func update(authResult: AuthService.AuthResult) {
        identity = .loggedIn(sessionID: authResult.sessionID, accountID: nil)
        authErrorMessage = nil
    }
    
    /// 更新為 guest 身分（可評分，帶到期時間）
    func updateGuest(sessionID: String, expiresAt: Date?) {
        identity = .guest(guestSessionID: sessionID, expiresAt: expiresAt)
        authErrorMessage = nil
    }
    
    /// 是否為登入身分
    var isAuthenticated: Bool {
        switch identity {
        case .loggedIn, .guest:
            return true
        case .anonymous:
            return false
        }
    }
    
    /// 記錄錯誤訊息
    func setError(_ message: String) {
        authErrorMessage = message
    }
    
    /// 以 TMDB 帳密登入建立 session，成功後更新為 logged in 身分
    /// - Parameters:
    ///   - username: TMDB 使用者名稱（非 email）
    ///   - password: TMDB 密碼（僅用於本次請求，不應持久化）
    func loginWithTMDBCredentials(username: String, password: String) async {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !password.isEmpty else {
            setError("請輸入 TMDB 使用者名稱與密碼")
            return
        }
        do {
            let result = try await authService.createSessionFromLogin(username: username, password: password)
            update(authResult: result)
        } catch {
            setError("登入失敗：\(error.localizedDescription)")
        }
    }

    /// 建立訪客 session 並更新為 guest 身分
    func loginAsGuest() async {
        do {
            let result = try await authService.createGuestSession()
            updateGuest(sessionID: result.sessionID, expiresAt: result.expiresAt)
        } catch {
            setError("訪客登入失敗：\(error.localizedDescription)")
        }
    }
    
    /// 處理 TMDB 授權回呼，交換 request token 為 session 並更新登入狀態
    /// - Parameter url: `movieexplorer://auth/callback?request_token=...&approved=true` 格式的回呼網址
    func handleAuthCallback(url: URL) async {
        guard let payload = authService.parseCallback(url: url) else { return }
        guard payload.approved else {
            setError("授權未通過，請重試")
            return
        }
        do {
            let result = try await authService.exchangeSession(requestToken: payload.requestToken)
            update(authResult: result)
        } catch {
            setError("交換 session 失敗：\(error.localizedDescription)")
        }
    }
    
    /// 重置為匿名狀態
    func reset() {
        identity = .anonymous
        authErrorMessage = nil
    }
}
