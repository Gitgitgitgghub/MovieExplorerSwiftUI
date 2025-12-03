//
//  Genre.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

struct MovieGenres: TMDBEndpointProtocol {
    typealias Response = GenreResponse

    var path: String { "/genre/movie/list" }
    var queryItems: [URLQueryItem] { [] }
}
