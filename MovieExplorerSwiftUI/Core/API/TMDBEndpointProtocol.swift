//
//  TMDBEndpointProtocol.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import Foundation

/// TMDB API 端點協定，定義路徑與查詢參數並指定回應型別
protocol TMDBEndpointProtocol {
    
    associatedtype Response: Decodable
    
    /// 端點路徑（含動態路徑參數）
    var path: String { get }
    /// 查詢參數鍵值對（不含 API key 與語系）
    var parameters: [String: String] { get }
}

extension TMDBEndpointProtocol {
    /// 預設無額外查詢參數
    var parameters: [String: String] { [:] }
}
