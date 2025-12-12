//
//  Genre.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

/// 取得電影類別清單
struct MovieGenres: TMDBEndpointProtocol {
    typealias Response = GenreResponse

    /// `/genre/movie/list`
    var path: String { "/genre/movie/list" }
}
