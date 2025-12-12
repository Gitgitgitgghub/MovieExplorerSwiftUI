//
//  Configuration.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/02.
//

import Foundation

/// 取得 TMDB 設定（影像基底網址等）
struct ConfigurationDetails: TMDBEndpointProtocol {
    typealias Response = ConfigurationDetailsResponse

    /// `/configuration`
    var path: String { "/configuration" }
}
