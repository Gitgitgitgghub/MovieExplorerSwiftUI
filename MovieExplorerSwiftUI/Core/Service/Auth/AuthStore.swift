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

    /// 授權流程錯誤：提供可直接顯示給使用者的訊息。
    enum AuthError: LocalizedError, Equatable {
        /// 使用者名稱或密碼未填
        case missingCredentials
        /// 授權未通過（使用者在 TMDB 授權頁按下拒絕/取消）
        case authorizationNotApproved

        var errorDescription: String? {
            switch self {
            case .missingCredentials:
                return "請輸入 TMDB 使用者名稱與密碼"
            case .authorizationNotApproved:
                return "授權未通過，請重試"
            }
        }
    }
    
    /// 授權流程服務（負責解析回呼與交換 session）
    private let authService: AuthService
    /// 授權憑證持久化儲存（用於跨重啟維持登入狀態）
    private let credentialStore: AuthCredentialStore
    
    /// 當前使用者身分（登入/訪客/匿名）
    @Published var identity: AuthIdentity = .anonymous
    
    /// 建立 `AuthStore`，可注入測試用的 `AuthService` 與憑證儲存層
    /// - Parameters:
    ///   - authService: 授權流程服務（預設使用真實 `AuthService`）
    ///   - credentialStore: 憑證持久化儲存（預設使用 Keychain）
    init(
        authService: AuthService = AuthService(),
        credentialStore: AuthCredentialStore = AuthKeychainStore()
    ) {
        self.authService = authService
        self.credentialStore = credentialStore
        restorePersistedIdentity()
    }
    
    /// 以登入結果更新為 loggedIn 狀態
    func update(authResult: AuthService.AuthResult) {
        identity = .loggedIn(sessionID: authResult.sessionID, accountID: nil)
        credentialStore.writeSessionID(authResult.sessionID)
    }
    
    /// 更新為 guest 身分（可評分，帶到期時間）
    func updateGuest(sessionID: String, expiresAt: Date?) {
        identity = .guest(guestSessionID: sessionID, expiresAt: expiresAt)
        credentialStore.writeGuestSession(sessionID: sessionID, expiresAt: expiresAt)
    }
    
    /// 是否為登入身分
    var isAuthenticated: Bool {
        switch identity {
        case .loggedIn, .guest:
            return !isGuestExpired
        case .anonymous:
            return false
        }
    }
    
    /// 以 TMDB 帳密登入建立 session，成功後更新為 logged in 身分
    /// - Parameters:
    ///   - username: TMDB 使用者名稱（非 email）
    ///   - password: TMDB 密碼（僅用於本次請求，不應持久化）
    func loginWithTMDBCredentials(username: String, password: String) async throws {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !password.isEmpty else {
            throw AuthError.missingCredentials
        }
        let result = try await authService.createSessionFromLogin(username: username, password: password)
        update(authResult: result)
    }

    /// 建立訪客 session 並更新為 guest 身分
    func loginAsGuest() async throws {
        let result = try await authService.createGuestSession()
        updateGuest(sessionID: result.sessionID, expiresAt: result.expiresAt)
    }
    
    /// 處理 TMDB 授權回呼，交換 request token 為 session 並更新登入狀態
    /// - Parameter url: `movieexplorer://auth/callback?request_token=...&approved=true` 格式的回呼網址
    func handleAuthCallback(url: URL) async throws {
        guard let payload = authService.parseCallback(url: url) else { return }
        guard payload.approved else {
            throw AuthError.authorizationNotApproved
        }
        let result = try await authService.exchangeSession(requestToken: payload.requestToken)
        update(authResult: result)
    }
    
    /// 重置為匿名狀態
    func reset() {
        identity = .anonymous
    }

    /// 登出並清除持久化憑證（回到登入頁）
    func logout() {
        credentialStore.clearAll()
        reset()
    }

    /// 若訪客 session 已過期，則清除訪客憑證並回到登入頁
    func invalidateGuestSessionIfExpired() {
        guard isGuestExpired else { return }
        credentialStore.clearGuestSession()
        reset()
    }
}

private extension AuthStore {

    /// 訪客 session 是否已過期（非訪客身分時一律為 false）
    var isGuestExpired: Bool {
        guard case let .guest(_, expiresAt) = identity else { return false }
        guard let expiresAt else { return false }
        return Date() >= expiresAt
    }

    /// 從持久化儲存還原身分（優先還原登入 session，其次才是訪客 session）
    func restorePersistedIdentity() {
        if let sessionID = credentialStore.readSessionID() {
            identity = .loggedIn(sessionID: sessionID, accountID: nil)
            return
        }

        if let guest = credentialStore.readGuestSession() {
            if let expiresAt = guest.expiresAt, Date() >= expiresAt {
                credentialStore.clearGuestSession()
                identity = .anonymous
                return
            }
            identity = .guest(guestSessionID: guest.sessionID, expiresAt: guest.expiresAt)
        }
    }
}
