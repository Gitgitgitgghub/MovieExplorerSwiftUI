//
//  ConfigurationDetailsResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/02.
//

import Foundation

struct ConfigurationDetailsResponse: Decodable {
    let images: TMDBImageConfiguration
    let changeKeys: [String]

    enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
}

struct TMDBImageConfiguration: Codable {
    let baseURL: String
    let secureBaseURL: String
    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]
    let stillSizes: [String]

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}

extension TMDBImageConfiguration {
    static let fallback = TMDBImageConfiguration(
        baseURL: "http://image.tmdb.org/t/p/",
        secureBaseURL: "https://image.tmdb.org/t/p/",
        backdropSizes: ["w300", "w780", "w1280"],
        logoSizes: ["w185", "w300", "w500"],
        posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780"],
        profileSizes: ["w45", "w185", "h632"],
        stillSizes: ["w92", "w185", "w300"]
    )

    var posterBaseURL: String {
        secureBaseURL + preferredSize(from: posterSizes, desired: ["w500", "w342", "w185"], fallback: "w500")
    }

    var backdropBaseURL: String {
        secureBaseURL + preferredSize(from: backdropSizes, desired: ["w780", "w1280", "w300"], fallback: "w780")
    }

    private func preferredSize(from available: [String], desired: [String], fallback: String) -> String {
        for size in desired where available.contains(size) {
            return size
        }
        return available.last ?? fallback
    }
}

extension ConfigurationDetailsResponse: Mockable {
    static var mockJson: String {
        """
        {
          "images": {
            "base_url": "http://image.tmdb.org/t/p/",
            "secure_base_url": "https://image.tmdb.org/t/p/",
            "backdrop_sizes": ["w300", "w780", "w1280", "original"],
            "logo_sizes": ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            "poster_sizes": ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            "profile_sizes": ["w45", "w185", "h632", "original"],
            "still_sizes": ["w92", "w185", "w300", "original"]
          },
          "change_keys": ["adult", "air_date", "also_known_as"]
        }
        """
    }
}
