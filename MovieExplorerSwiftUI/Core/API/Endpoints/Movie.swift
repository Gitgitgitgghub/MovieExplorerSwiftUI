//
//  Movies.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

struct MovieDetails: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    let movieID: Int
    var path: String { "/movie/\(movieID)" }
    var queryItems: [URLQueryItem] { [] }
}

struct MovieCredits: TMDBEndpointProtocol {
    typealias Response = CreditsResponse

    let movieID: Int
    var path: String { "/movie/\(movieID)/credits" }
    var queryItems: [URLQueryItem] { [] }
}

struct TrendingMovies: TMDBEndpointProtocol {
    
    typealias Response = MovieResponse

    var path: String { "/trending/movie/day" }
    var queryItems: [URLQueryItem] { [] }
}

struct PopularMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    var path: String { "/movie/popular" }
    var queryItems: [URLQueryItem] { [] }
}

struct TopRatedMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    var path: String { "/movie/top_rated" }
    var queryItems: [URLQueryItem] { [] }
}

struct UpcomingMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    var path: String { "/movie/upcoming" }
    var queryItems: [URLQueryItem] { [] }
}

struct NowPlayingMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    var path: String { "/movie/now_playing" }
    var queryItems: [URLQueryItem] { [] }
}

struct SimilarMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    let id: Int
    var path: String { "/movie/\(id)/similar" }
    var queryItems: [URLQueryItem] { [] }
}
