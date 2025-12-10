//
//  PersonMovieCreditsResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/10.
//

import Foundation

struct PersonMovieCreditsResponse: Decodable {
    let id: Int
    let cast: [PersonMovieCast]
    let crew: [PersonMovieCrew]
}

struct PersonMovieCast: Codable, Identifiable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let character: String?
    let creditID: String
    let genreIDS: [Int]
    let id: Int
    let mediaType: MediaType?
    let originalLanguage: OriginalLanguage
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case character
        case creditID = "credit_id"
        case genreIDS = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case order
    }
}

struct PersonMovieCrew: Codable, Identifiable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let creditID: String
    let department: String
    let genreIDS: [Int]
    let id: Int
    let job: String
    let mediaType: MediaType?
    let originalLanguage: OriginalLanguage
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case creditID = "credit_id"
        case department
        case genreIDS = "genre_ids"
        case id
        case job
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension PersonMovieCast {
    var posterURL: URL? {
        guard let posterPath, !posterPath.isEmpty else { return nil }
        return URL(string: TMDBConfig.posterBaseURL + posterPath)
    }

    var backdropURL: URL? {
        guard let backdropPath, !backdropPath.isEmpty else { return nil }
        return URL(string: TMDBConfig.backdropBaseURL + backdropPath)
    }
}

extension PersonMovieCrew {
    var posterURL: URL? {
        guard let posterPath, !posterPath.isEmpty else { return nil }
        return URL(string: TMDBConfig.posterBaseURL + posterPath)
    }

    var backdropURL: URL? {
        guard let backdropPath, !backdropPath.isEmpty else { return nil }
        return URL(string: TMDBConfig.backdropBaseURL + backdropPath)
    }
}

// MARK: - Mock
extension PersonMovieCreditsResponse: Mockable {
    static var mockJson: String {
        """
        {
          "id": 287,
          "cast": [
            {
              "adult": false,
              "backdrop_path": "/2sAl8nxr1KX9cXj6Jdj0ORkYYOY.jpg",
              "character": "Rusty Ryan",
              "credit_id": "52fe4255c3a36847f80181b9",
              "genre_ids": [28, 80, 53],
              "id": 161,
              "media_type": "movie",
              "original_language": "en",
              "original_title": "Ocean's Twelve",
              "overview": "Danny Ocean reunites his friends for another heist in Europe.",
              "popularity": 57.312,
              "poster_path": "/4eCFDi1nB3PEfrq5ulJXryI2PSE.jpg",
              "release_date": "2004-12-09",
              "title": "Ocean's Twelve",
              "video": false,
              "vote_average": 6.6,
              "vote_count": 8495,
              "order": 0
            }
          ],
          "crew": [
            {
              "adult": false,
              "backdrop_path": "/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg",
              "credit_id": "52fe4255c3a36847f80181c9",
              "department": "Production",
              "genre_ids": [18],
              "id": 25,
              "job": "Producer",
              "media_type": "movie",
              "original_language": "en",
              "original_title": "Fight Club",
              "overview": "An insomniac office worker crosses paths with a soap maker and forms an underground club.",
              "popularity": 99.12,
              "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
              "release_date": "1999-10-15",
              "title": "Fight Club",
              "video": false,
              "vote_average": 8.4,
              "vote_count": 28539
            }
          ]
        }
        """
    }
}
