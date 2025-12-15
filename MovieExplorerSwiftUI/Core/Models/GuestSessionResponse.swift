//
//  GuestSessionResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/15.
//

import Foundation

/// 建立 TMDB 訪客 session 的回應（可用於評分等受限功能）
struct GuestSessionResponse: Decodable {
    /// API 是否成功
    let success: Bool
    /// 取得的 guest session ID
    let guestSessionID: String
    /// session 到期時間（字串格式）
    let expiresAt: String

    private enum CodingKeys: String, CodingKey {
        case success
        case guestSessionID = "guest_session_id"
        case expiresAt = "expires_at"
    }
}

extension GuestSessionResponse: Mockable {
    /// 測試/預覽用訪客 session 建立回應假資料
    static var mockJson: String {
        """
        {
          "success": true,
          "guest_session_id": "mock_guest_session_id",
          "expires_at": "2025-12-31 23:59:59 UTC"
        }
        """
    }
}

