//
//  Person.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/10.
//

import Foundation

/// 取得人物詳細資訊
struct PersonDetails: TMDBEndpointProtocol {
    typealias Response = PersonDetailResponse

    let personID: Int
    /// `/person/{person_id}`
    var path: String { "/person/\(personID)" }
}

/// 取得人物的電影參與清單
struct PersonMovieCredits: TMDBEndpointProtocol {
    typealias Response = PersonMovieCreditsResponse

    let personID: Int
    /// `/person/{person_id}/movie_credits`
    var path: String { "/person/\(personID)/movie_credits" }
}
