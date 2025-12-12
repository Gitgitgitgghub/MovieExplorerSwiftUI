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
    
    private let apiKey = TMDBConfig.apiKey
    private let baseURL = TMDBConfig.baseURL
    
    /// 建立 URL 後送出請求並解碼為端點宣告的 Response
    func request<E: TMDBEndpointProtocol>(_ endpoint: E) async throws -> E.Response {
        
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }
        
        var parameters = endpoint.parameters
        parameters["api_key"] = apiKey
        parameters["language"] = "en-US"

        if !parameters.isEmpty {
            components.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }

        let url = components.url!
        let (data, _) = try await URLSession.shared.data(from: url)
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
