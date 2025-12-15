//
//  Auth.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/12.
//

import Foundation

/// 取得 TMDB request token（用於導向官方授權頁）
struct RequestToken: TMDBEndpointProtocol {
    typealias Response = RequestTokenResponse

    /// `/authentication/token/new`
    var path: String { "/authentication/token/new" }
    /// 此端點需使用 API Key 查詢參數
    var authMethodOverride: TMDBService.AuthMethod? { .apiKey(TMDBConfig.apiKey) }
}

/// 使用授權過的 request token 建立 v3 session
struct CreateSession: TMDBEndpointProtocol {
    typealias Response = CreateSessionResponse

    /// 授權過的 request token
    let requestToken: String

    var method: HTTPMethod { .post }
    /// `/authentication/session/new`
    var path: String { "/authentication/session/new" }
    /// 此端點需使用 API Key 查詢參數
    var authMethodOverride: TMDBService.AuthMethod? { .apiKey(TMDBConfig.apiKey) }
    /// JSON body：`{"request_token": "..."}`
    var body: Data? {
        try? JSONEncoder().encode(["request_token": requestToken])
    }
    var headers: [String: String] { ["Content-Type": "application/json"] }
}

/// 以 TMDB 帳號密碼驗證 request token（建立「從登入建立 session」流程用）
struct ValidateTokenWithLogin: TMDBEndpointProtocol {
    typealias Response = RequestTokenResponse

    /// TMDB 使用者名稱（非 email）
    let username: String
    /// TMDB 密碼（僅用於本次請求，不應持久化）
    let password: String
    /// 由 `/authentication/token/new` 取得的 request token
    let requestToken: String

    var method: HTTPMethod { .post }
    /// `/authentication/token/validate_with_login`
    var path: String { "/authentication/token/validate_with_login" }
    /// 此端點需使用 API Key 查詢參數
    var authMethodOverride: TMDBService.AuthMethod? { .apiKey(TMDBConfig.apiKey) }
    /// JSON body：`{"username":"...","password":"...","request_token":"..."}`
    var body: Data? {
        try? JSONEncoder().encode([
            "username": username,
            "password": password,
            "request_token": requestToken
        ])
    }
    var headers: [String: String] { ["Content-Type": "application/json"] }
}
