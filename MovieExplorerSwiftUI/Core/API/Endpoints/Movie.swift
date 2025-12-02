//
//  Movies.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

struct TrendingMovies: TMDBEndpoint {
    
    typealias Response = MovieResponse

    var path: String { "/trending/movie/day" }
    var queryItems: [URLQueryItem] { [] }
}

struct PopularMovies: TMDBEndpoint {
    typealias Response = MovieResponse

    var path: String { "/movie/popular" }
    var queryItems: [URLQueryItem] { [] }
}

struct TopRatedMovies: TMDBEndpoint {
    typealias Response = MovieResponse

    var path: String { "/movie/top_rated" }
    var queryItems: [URLQueryItem] { [] }
}

struct UpcomingMovies: TMDBEndpoint {
    typealias Response = MovieResponse

    var path: String { "/movie/upcoming" }
    var queryItems: [URLQueryItem] { [] }
}

struct NowPlayingMovies: TMDBEndpoint {
    typealias Response = MovieResponse

    var path: String { "/movie/now_playing" }
    var queryItems: [URLQueryItem] { [] }
}

struct MovieDetails: TMDBEndpoint {
    typealias Response = MovieResponse

    let movieID: Int
    var path: String { "/movie/\(movieID)" }
    var queryItems: [URLQueryItem] { [] }
}

struct MovieCredits: TMDBEndpoint {
    typealias Response = CreditsResponse

    let movieID: Int
    var path: String { "/movie/\(movieID)/credits" }
    var queryItems: [URLQueryItem] { [] }
}

struct SimilarMovies: TMDBEndpoint {
    typealias Response = MovieResponse

    let id: Int
    var path: String { "/movie/\(id)/similar" }
    var queryItems: [URLQueryItem] { [] }
}
