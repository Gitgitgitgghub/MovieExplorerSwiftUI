//
//  TMDBService.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import Foundation

/// TMDB API 請求服務介面
protocol TMDBServiceProtocol: Sendable {
    /// 發送指定端點並解碼回應
    func request<E: TMDBEndpointProtocol>(_ endpoint: E) async throws -> E.Response
    
}

/// 實際呼叫 TMDB API 的服務
final class TMDBService: TMDBServiceProtocol {
    
    /// 認證方式（API Key 或 v4 Bearer Token）
    enum AuthMethod {
        /// 以 query string 帶入 v3 API Key
        case apiKey(String)
        /// 使用 v4 access token 放入 Authorization 標頭
        case bearerToken(String)
    }

    /// API 認證模式（query api_key 或 Authorization Bearer）
    private let authMethod: AuthMethod
    /// TMDB API 基底網址
    private let baseURL = TMDBConfig.baseURL
    /// 預設語系參數（可由 endpoint 覆寫）
    private let defaultLanguage: String

    /// 初始化服務，若提供 access token 則使用 Bearer，否則回退 API Key
    init(
        authMethod: AuthMethod = TMDBConfig.accessToken.flatMap { .bearerToken($0) } ?? .apiKey(TMDBConfig.apiKey),
        defaultLanguage: String = "en-US"
    ) {
        self.authMethod = authMethod
        self.defaultLanguage = defaultLanguage
    }
    
    /// 建立 URL 後送出請求並解碼為端點宣告的 Response
    func request<E: TMDBEndpointProtocol>(_ endpoint: E) async throws -> E.Response {
        
        let effectiveAuth: AuthMethod = endpoint.authMethodOverride ?? authMethod

        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }
        
        var parameters = endpoint.parameters
        if parameters["language"] == nil {
            parameters["language"] = defaultLanguage
        }

        switch effectiveAuth {
        case .apiKey(let key):
            parameters["api_key"] = key
        case .bearerToken:
            break
        }

        if !parameters.isEmpty {
            components.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }

        let url = components.url!
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if case .bearerToken(let token) = effectiveAuth {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, _) = try await URLSession.shared.data(for: request)
        // 先看看實際拿到什麼
        //print(String(data: data, encoding: .utf8) ?? "no string")
        return try JSONDecoder().decode(E.Response.self, from: data)
    }
    
}


//MARK : - Fake Service for Testing
/// 測試用假服務，優先回傳 Response 型別的 mock
final class FakeTMDBService: TMDBServiceProtocol {
    
    /// 回傳 mock 資料，若未提供 mock 則拋出致命錯誤
    func request<E: TMDBEndpointProtocol>(_ endpoint: E) async throws -> E.Response {
        if let mockType = E.Response.self as? (any Mockable.Type),
           let decoded = mockType.mock as? E.Response {
            return decoded
        }
        fatalError("No mockJson provided for \(E.Response.self)")
    }
}
