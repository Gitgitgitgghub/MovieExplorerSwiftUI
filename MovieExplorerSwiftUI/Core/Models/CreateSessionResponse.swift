//
//  CreateSessionResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/12.
//

import Foundation

/// 使用 request token 建立 v3 session 的回應
struct CreateSessionResponse: Decodable {
    /// API 是否成功
    let success: Bool
    /// 取得的 session ID
    let sessionID: String

    private enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}

extension CreateSessionResponse: Mockable {
    /// 測試/預覽用 session 建立回應假資料
    static var mockJson: String {
        """
        {
          "success": true,
          "session_id": "mock_session_id"
        }
        """
    }
}
