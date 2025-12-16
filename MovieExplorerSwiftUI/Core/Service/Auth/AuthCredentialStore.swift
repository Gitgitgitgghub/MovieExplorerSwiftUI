//
//  AuthCredentialStore.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/16.
//

import Foundation

/// 授權憑證的持久化存取介面（用於保存/還原 TMDB session）
protocol AuthCredentialStore {

    /// 讀取登入用 v3 session id（若不存在則為 nil）
    func readSessionID() -> String?

    /// 讀取訪客 session 與到期時間（若不存在則為 nil）
    func readGuestSession() -> GuestSessionCredential?

    /// 寫入登入用 v3 session id
    func writeSessionID(_ sessionID: String)

    /// 寫入訪客 session 與到期時間
    func writeGuestSession(sessionID: String, expiresAt: Date?)

    /// 清除所有授權憑證（登入與訪客）
    func clearAll()

    /// 清除訪客 session 憑證
    func clearGuestSession()
}

/// 訪客 session 的持久化資料（guest_session_id 與到期時間）
struct GuestSessionCredential: Equatable {

    /// 訪客 session id（guest_session_id）
    let sessionID: String

    /// 到期時間（若無法解析/未提供則為 nil）
    let expiresAt: Date?
}

