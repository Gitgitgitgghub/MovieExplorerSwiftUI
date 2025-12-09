//
//  MovieResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import Foundation


struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Movie: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let title, originalTitle, overview: String
    let posterPath: String?
    let mediaType: MediaType?
    let originalLanguage: OriginalLanguage
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
}

enum OriginalLanguage: Codable, Equatable {
    case en
    case fr
    case zh
    case other(String)

    private var value: String {
        switch self {
        case .en: return "en"
        case .fr: return "fr"
        case .zh: return "zh"
        case .other(let code): return code
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        switch code {
        case "en": self = .en
        case "fr": self = .fr
        case "zh": self = .zh
        default: self = .other(code)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - 方便 UI 用的 computed properties
extension Movie {

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

    var ratingText: String {
        guard voteAverage != 0 else { return "-" }
        return String(format: "%.1f", voteAverage)
    }

    func formattedReleaseDate(fallback: String = "日期待定") -> String {
        guard let releaseDate, !releaseDate.isEmpty else { return fallback }
        let parser = DateFormatter.make(
            format: "yyyy-MM-dd",
            locale: Locale(identifier: "en_US_POSIX")
        )
        if let date = parser.date(from: releaseDate) {
            return Self.releaseDateDisplayFormatter.string(from: date)
        }
        return releaseDate
    }

    private static let releaseDateDisplayFormatter: DateFormatter = .make(
        format: "M月d日",
        locale: Locale(identifier: "zh_TW")
    )
}

//MARK: - Mock Data for Preview
extension MovieResponse: Mockable {

    static let mockJson =
"""
{"page":1,"results":[{"adult":false,"backdrop_path":"/5h2EsPKNDdB3MAtOk9MB9Ycg9Rz.jpg","id":1084242,"title":"Zootopia 2","original_title":"Zootopia 2","overview":"After cracking the biggest case in Zootopia's history, rookie cops Judy Hopps and Nick Wilde find themselves on the twisting trail of a great mystery when Gary De’Snake arrives and turns the animal metropolis upside down. To crack the case, Judy and Nick must go undercover to unexpected new parts of town, where their growing partnership is tested like never before.","poster_path":"/oJ7g2CifqpStmoYQyaLQgEU32qO.jpg","media_type":"movie","original_language":"en","genre_ids":[16,10751,35,12,9648],"popularity":372.412,"release_date":"2025-11-26","video":false,"vote_average":7.6,"vote_count":69},{"adult":false,"backdrop_path":"/nt0HRxlzOXRpPJtl2FmeBCO6MeR.jpg","id":1246049,"title":"Dracula","original_title":"Dracula","overview":"When a 15th-century prince denounces God after the devastating loss of his wife, he inherits an eternal curse: he becomes Dracula. Condemned to wander the centuries, he defies fate and death itself, guided by a single hope — to be reunited with his lost love.","poster_path":"/ykyRfv7JDofLxXLAwtLXaSuaFfM.jpg","media_type":"movie","original_language":"fr","genre_ids":[27,14,10749],"popularity":54.1044,"release_date":"2025-07-30","video":false,"vote_average":7.1,"vote_count":449},{"adult":false,"backdrop_path":"/3lv0X3C5CoBGQuXioTlPORsu6Qm.jpg","id":1218762,"title":"Jingle Bell Heist","original_title":"Jingle Bell Heist","overview":"Two down-on-their-luck hourly workers team up to rob a posh London department store on Christmas Eve. Will they steal each other's hearts along the way?","poster_path":"/w2gsk9B7AJHKaN47IULaIbNHFdx.jpg","media_type":"movie","original_language":"en","genre_ids":[10749,80,35],"popularity":63.4794,"release_date":"2025-11-25","video":false,"vote_average":6.2,"vote_count":24},{"adult":false,"backdrop_path":"/uPvsuTYc2fgEYgp3Ib2INoGep0n.jpg","id":701387,"title":"Bugonia","original_title":"Bugonia","overview":"Two conspiracy obsessed young men kidnap the high-powered CEO of a major company, convinced that she is an alien intent on destroying planet Earth.","poster_path":"/oxgsAQDAAxA92mFGYCZllgWkH9J.jpg","media_type":"movie","original_language":"en","genre_ids":[35,80,878],"popularity":109.3434,"release_date":"2025-10-23","video":false,"vote_average":7.6,"vote_count":451},{"adult":false,"backdrop_path":"/w9D45Y8WkmeGmuExerGNq3Owy8U.jpg","id":1448560,"title":"Wildcat","original_title":"Wildcat","overview":"An ex-black ops team reunite to pull off a desperate heist in order to save the life of their leader’s eight-year-old daughter.","poster_path":"/h893ImjM6Fsv5DFhKJdlZFZIJno.jpg","media_type":"movie","original_language":"en","genre_ids":[28,53,80],"popularity":26.3743,"release_date":"2025-11-19","video":false,"vote_average":5.4,"vote_count":4},{"adult":false,"backdrop_path":"/l8pwO23MCvqYumzozpxynCNfck1.jpg","id":967941,"title":"Wicked: For Good","original_title":"Wicked: For Good","overview":"As an angry mob rises against the Wicked Witch, Glinda and Elphaba will need to come together one final time. With their singular friendship now the fulcrum of their futures, they will need to truly see each other, with honesty and empathy, if they are to change themselves, and all of Oz, for good.","poster_path":"/si9tolnefLSUKaqQEGz1bWArOaL.jpg","media_type":"movie","original_language":"en","genre_ids":[14,12,10749],"popularity":230.2695,"release_date":"2025-11-19","video":false,"vote_average":6.8,"vote_count":272}],"total_pages":500,"total_results":10000}
"""
}

extension Movie: Mockable {
    static var mockJson: String {
        """
        {"adult":false,"backdrop_path":"/5h2EsPKNDdB3MAtOk9MB9Ycg9Rz.jpg","id":1084242,"title":"Zootopia 2","original_title":"Zootopia 2","overview":"After cracking the biggest case in Zootopia's history, rookie cops Judy Hopps and Nick Wilde find themselves on the twisting trail of a great mystery when Gary De’Snake arrives and turns the animal metropolis upside down. To crack the case, Judy and Nick must go undercover to unexpected new parts of town, where their growing partnership is tested like never before.","poster_path":"/oJ7g2CifqpStmoYQyaLQgEU32qO.jpg","media_type":"movie","original_language":"en","genre_ids":[16,10751,35,12,9648],"popularity":372.412,"release_date":"2025-11-26","video":false,"vote_average":7.6,"vote_count":69}
        """
    }

}
