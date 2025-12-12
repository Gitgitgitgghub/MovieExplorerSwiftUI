//
//  TMDBEndpointProtocol.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import Foundation

/// TMDB API 端點協定，定義路徑、方法、查詢參數與回應型別
protocol TMDBEndpointProtocol {
    
    associatedtype Response: Decodable
    
    /// HTTP 方法（預設 GET）
    var method: HTTPMethod { get }
    /// 指定端點的認證方式（若為 nil 則採用 TMDBService 初始化的設定）
    var authMethodOverride: TMDBService.AuthMethod? { get }
    /// 端點路徑（含動態路徑參數）
    var path: String { get }
    /// 查詢參數鍵值對（不含 API key 與語系）
    var parameters: [String: String] { get }
    /// Request body（若需要 POST/PUT，預設 nil）
    var body: Data? { get }
    /// 額外標頭（預設空）
    var headers: [String: String] { get }
}

extension TMDBEndpointProtocol {
    var method: HTTPMethod { .get }
    var authMethodOverride: TMDBService.AuthMethod? { nil }
    /// 預設無額外查詢參數
    var parameters: [String: String] { [:] }
    var body: Data? { nil }
    var headers: [String: String] { [:] }
}

/// 簡易 HTTP 方法定義
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}
