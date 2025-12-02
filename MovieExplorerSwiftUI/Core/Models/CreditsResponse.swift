//
//  CreditsResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//


import Foundation

struct CreditsResponse: Codable {
    let id: Int
    let cast: [Cast]
    // 之後有需要再加 crew
    // let crew: [Crew]
}

struct Cast: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
        case order
    }
}

extension Cast {
    private static let profileBaseURL = "https://image.tmdb.org/t/p/w185"

    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: Cast.profileBaseURL + path)
    }

    var displayCharacter: String {
        character ?? ""
    }
}
