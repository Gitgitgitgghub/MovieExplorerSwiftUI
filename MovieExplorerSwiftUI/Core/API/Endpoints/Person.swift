//
//  Person.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/10.
//

import Foundation

struct PersonDetails: TMDBEndpointProtocol {
    typealias Response = PersonDetailResponse

    let personID: Int
    var path: String { "/person/\(personID)" }
    var queryItems: [URLQueryItem] { [] }
}

struct PersonMovieCredits: TMDBEndpointProtocol {
    typealias Response = PersonMovieCreditsResponse

    let personID: Int
    var path: String { "/person/\(personID)/movie_credits" }
    var queryItems: [URLQueryItem] { [] }
}
