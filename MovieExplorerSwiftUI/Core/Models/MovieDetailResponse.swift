//
//  MovieDetailResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/03.
//

import Foundation

struct MovieDetailResponse: Codable, Identifiable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let originalLanguage: OriginalLanguage
    let genres: [Genre]
    let popularity: Double
    let releaseDate: String?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let voteAverage: Double
    let voteCount: Int
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case genres
        case popularity
        case releaseDate = "release_date"
        case runtime
        case status
        case tagline
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case homepage
    }
}

// MARK: - 方便 UI 使用的 computed properties
extension MovieDetailResponse {

    var posterURL: URL? {
        guard let posterPath, !posterPath.isEmpty else { return nil }
        return URL(string: TMDBConfig.posterBaseURL + posterPath)
    }

    var backdropURL: URL? {
        guard let backdropPath, !backdropPath.isEmpty else { return nil }
        return URL(string: TMDBConfig.backdropBaseURL + backdropPath)
    }

    var yearText: String {
        guard let releaseDate, releaseDate.count >= 4 else { return "" }
        return String(releaseDate.prefix(4))
    }
}

extension MovieDetailResponse: Mockable {
    static var mockJson: String {
        """
        {
          "adult": false,
          "backdrop_path": "/oJ7g2CifqpStmoYQyaLQgEU32qO.jpg",
          "belongs_to_collection": {
            "id": 1240037,
            "name": "Zootopia Collection",
            "poster_path": "/k7fAd6lqnxCKZqoPBIXcjM898Gq.jpg",
            "backdrop_path": "/nuUZ35KwK4U1FfKuj5PIsHK6NlJ.jpg"
          },
          "budget": 0,
          "genres": [
            { "id": 16, "name": "Animation" },
            { "id": 35, "name": "Comedy" },
            { "id": 10751, "name": "Family" }
          ],
          "homepage": "https://disney.com/zootopia2",
          "id": 1084242,
          "imdb_id": "tt28361428",
          "original_language": "en",
          "original_title": "Zootopia 2",
          "overview": "After cracking the biggest case in Zootopia's history, Judy and Nick face a new mystery that shakes the city.",
          "popularity": 372.412,
          "poster_path": "/oJ7g2CifqpStmoYQyaLQgEU32qO.jpg",
          "release_date": "2025-11-26",
          "revenue": 0,
          "runtime": 110,
          "status": "Planned",
          "tagline": "Trust your partners.",
          "title": "Zootopia 2",
          "video": false,
          "vote_average": 7.6,
          "vote_count": 69
        }
        """
    }
}
