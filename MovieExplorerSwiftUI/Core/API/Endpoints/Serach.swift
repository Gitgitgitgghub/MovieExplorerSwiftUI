//
//  Serach.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

struct SearchMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    let query: String

    var path: String { "/search/movie" }
    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "query", value: query)]
    }
}
