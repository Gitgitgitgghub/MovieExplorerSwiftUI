//
//  TMDBService.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import Foundation

protocol TMDBServiceProtocol {
    func request<E: TMDBEndpoint>(_ endpoint: E) async throws -> E.Response
}

final class TMDBService: TMDBServiceProtocol {
    
    private let apiKey = TMDBConfig.apiKey
    private let baseURL = TMDBConfig.baseURL
    
    func request<E: TMDBEndpoint>(_ endpoint: E) async throws -> E.Response {
        
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }
        
        var items = endpoint.queryItems
        items.append(URLQueryItem(name: "api_key", value: apiKey))
        items.append(URLQueryItem(name: "language", value: "en-US"))
        
        components.queryItems = items
        
        let url = components.url!
        let (data, _) = try await URLSession.shared.data(from: url)
        // 先看看實際拿到什麼
        //print(String(data: data, encoding: .utf8) ?? "no string")
        return try JSONDecoder().decode(E.Response.self, from: data)
    }
    
}


//MARK : - Fake Service for Testing
final class FakeTMDBService: TMDBServiceProtocol {
    
    func request<E: TMDBEndpoint>(_ endpoint: E) async throws -> E.Response {
        // 如果 Response 型別支援 Mockable → 回傳 fake
        if let mockType = E.Response.self as? (any Mockable.Type),
           let decoded = mockType.mock as? E.Response {
            return decoded
        }
        fatalError("No mockJson provided for \(E.Response.self)")
    }
}

