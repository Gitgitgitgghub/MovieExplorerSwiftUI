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

// MARK: - Mock
extension CreditsResponse: Mockable {
    static var mockJson: String {
        """
        {
          "id": 1084242,
          "cast": [
            {
              "id": 2037,
              "name": "Ginnifer Goodwin",
              "character": "Judy Hopps (voice)",
              "profile_path": "/aFF1ZZWHgmN4LCxfv7K5s8ygf2A.jpg",
              "order": 0
            },
            {
              "id": 134937,
              "name": "Jason Bateman",
              "character": "Nick Wilde (voice)",
              "profile_path": "/5jXb3MEHj7QqXVHJPxmgix0CUXV.jpg",
              "order": 1
            },
            {
              "id": 4785,
              "name": "Idris Elba",
              "character": "Chief Bogo (voice)",
              "profile_path": "/yXsqMeLZzgZvaeV1lI3pXAz3H3w.jpg",
              "order": 2
            }
          ]
        }
        """
    }
}
