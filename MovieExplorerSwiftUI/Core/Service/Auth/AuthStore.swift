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
    
    /// 當前使用者身分（登入/訪客/匿名）
    @Published var identity: AuthIdentity = .anonymous
    /// 授權相關錯誤訊息（顯示於 UI）
    @Published var authErrorMessage: String?
    
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
        if case .loggedIn = identity { return true }
        return false
    }
    
    /// 記錄錯誤訊息
    func setError(_ message: String) {
        authErrorMessage = message
    }
    
    /// 重置為匿名狀態
    func reset() {
        identity = .anonymous
        authErrorMessage = nil
    }
}
