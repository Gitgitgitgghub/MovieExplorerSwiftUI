//
//  AuthIdentity.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/13.
//

import Foundation

/// 使用者身分狀態（登入/訪客/匿名）
enum AuthIdentity: Equatable {
    /// 已登入，持有 v3 session id，必要時可補 account id
    case loggedIn(sessionID: String, accountID: Int?)
    /// 訪客身分（可評分），帶 guest_session_id 與到期時間
    case guest(guestSessionID: String, expiresAt: Date?)
    /// 未登入匿名狀態
    case anonymous
}
