//
//  RequestTokenResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/12.
//

import Foundation

/// TMDB request token 回應（用於授權流程）
struct RequestTokenResponse: Decodable {
    /// API 是否成功
    let success: Bool
    /// token 的到期時間（字串格式）
    let expiresAt: String
    /// 用於導向授權頁的 token
    let requestToken: String

    private enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
