//
//  PersonDetailResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/10.
//

import Foundation

struct PersonDetailResponse: Decodable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String?
    let deathday: String?
    let gender: Int?
    let homepage: String?
    let id: Int
    let imdbID: String?
    let knownForDepartment: String?
    let name: String
    let placeOfBirth: String?
    let popularity: Double
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography
        case birthday
        case deathday
        case gender
        case homepage
        case id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}

extension PersonDetailResponse {
    private static let profileBaseURL = "https://image.tmdb.org/t/p/w185"

    var profileURL: URL? {
        guard let path = profilePath, !path.isEmpty else { return nil }
        return URL(string: Self.profileBaseURL + path)
    }
}

// MARK: - Mock
extension PersonDetailResponse: Mockable {
    static var mockJson: String {
        """
        {
          "adult": false,
          "also_known_as": [
            "布萊德·彼特",
            "브래드 피트"
          ],
          "biography": "An American actor and producer known for diverse roles across drama and action.",
          "birthday": "1963-12-18",
          "deathday": null,
          "gender": 2,
          "homepage": null,
          "id": 287,
          "imdb_id": "nm0000093",
          "known_for_department": "Acting",
          "name": "Brad Pitt",
          "place_of_birth": "Shawnee, Oklahoma, USA",
          "popularity": 26.189,
          "profile_path": "/cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        }
        """
    }
}
