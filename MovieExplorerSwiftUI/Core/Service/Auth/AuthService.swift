//
//  AuthService.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/13.
//

import Foundation
import SwiftUI

/// TMDB 授權流程封裝：取得 request token、組授權網址、交換 session
struct AuthService {
    
    /// 授權結果
    struct AuthResult {
        /// 授權後取得的 v3 session id
        let sessionID: String
        /// 是否有標記為 approved=true
        let approved: Bool
        /// 原始 request token
        let requestToken: String
    }
    
    /// 授權回呼組件
    struct CallbackPayload {
        let requestToken: String
        let approved: Bool
    }
    
    private let service: TMDBServiceProtocol
    /// TMDB 授權回呼網址（需與 Info.plist 中的 URL scheme 對應）
    private let redirectURL: String = "movieexplorer://auth/callback"
    
    init(
        service: TMDBServiceProtocol = TMDBService()
    ) {
        self.service = service
    }
    
    /// 建立授權網址（含 request token 與 redirect_to）
    func authorizationURL() async throws -> URL {
        let tokenResponse: RequestTokenResponse = try await service.request(RequestToken())
        var components = URLComponents(string: "https://www.themoviedb.org/authenticate/\(tokenResponse.requestToken)")
        components?.queryItems = [
            URLQueryItem(name: "redirect_to", value: redirectURL)
        ]
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        return url
    }
    
    /// 從回呼 URL 解析授權 payload
    func parseCallback(url: URL) -> CallbackPayload? {
        guard url.scheme == "movieexplorer",
              url.host == "auth",
              url.path == "/callback" else {
            return nil
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let token = components?.queryItems?.first(where: { $0.name == "request_token" })?.value else {
            return nil
        }
        let approved = components?.queryItems?.first(where: { $0.name == "approved" })?.value == "true"
        return CallbackPayload(requestToken: token, approved: approved)
    }
    
    /// 將授權過的 request token 交換為 session id
    func exchangeSession(requestToken: String) async throws -> AuthResult {
        let sessionResponse: CreateSessionResponse = try await service.request(CreateSession(requestToken: requestToken))
        return AuthResult(sessionID: sessionResponse.sessionID, approved: true, requestToken: requestToken)
    }
}
