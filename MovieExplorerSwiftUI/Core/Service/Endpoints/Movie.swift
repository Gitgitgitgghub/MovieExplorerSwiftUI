//
//  Movies.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

/// 取得指定電影的詳細資訊
struct MovieDetails: TMDBEndpointProtocol {
    typealias Response = MovieDetailResponse

    let movieID: Int
    /// `/movie/{movie_id}`
    var path: String { "/movie/\(movieID)" }
}

/// 取得指定電影的演職員清單
struct MovieCredits: TMDBEndpointProtocol {
    typealias Response = CreditsResponse

    let movieID: Int
    /// `/movie/{movie_id}/credits`
    var path: String { "/movie/\(movieID)/credits" }
}

/// 取得指定電影的影片（預告、剪輯等）
struct MovieVideos: TMDBEndpointProtocol {
    typealias Response = MovieVideosResponse

    let movieID: Int
    /// `/movie/{movie_id}/videos`
    var path: String { "/movie/\(movieID)/videos" }
}

/// 取得趨勢電影清單（依時間窗）
struct TrendingMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    /// 時間窗（日或週）
    enum TimeWindow: String {
        /// 過去 24 小時熱門
        case day
        /// 過去 7 天熱門
        case week
    }

    let timeWindow: TimeWindow
    let page: Int?

    init(timeWindow: TimeWindow = .day, page: Int? = nil) {
        self.timeWindow = timeWindow
        self.page = page
    }

    var path: String { "/trending/movie/\(timeWindow.rawValue)" }
    /// 查詢參數：支援指定頁數
    var parameters: [String: String] {
        var params: [String: String] = [:]
        if let page {
            params["page"] = String(page)
        }
        return params
    }
}

/// 取得熱門電影清單（TMDB popular）
struct PopularMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    let page: Int?
    let region: String?

    init(page: Int? = nil, region: String? = nil) {
        self.page = page
        self.region = region
    }

    /// `/movie/popular`
    var path: String { "/movie/popular" }
    /// 查詢參數：可指定頁數與 ISO 3166-1 區域碼
    var parameters: [String: String] {
        var params: [String: String] = [:]
        if let page {
            params["page"] = String(page)
        }
        if let region {
            params["region"] = region
        }
        return params
    }
}

/// 取得高評分電影清單
struct TopRatedMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    let page: Int?
    let region: String?

    init(page: Int? = nil, region: String? = nil) {
        self.page = page
        self.region = region
    }

    /// `/movie/top_rated`
    var path: String { "/movie/top_rated" }
    /// 查詢參數：可指定頁數與 ISO 3166-1 區域碼
    var parameters: [String: String] {
        var params: [String: String] = [:]
        if let page {
            params["page"] = String(page)
        }
        if let region {
            params["region"] = region
        }
        return params
    }
}

/// 取得即將上映電影清單
struct UpcomingMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    let page: Int?
    let region: String?

    init(page: Int? = nil, region: String? = nil) {
        self.page = page
        self.region = region
    }

    /// `/movie/upcoming`
    var path: String { "/movie/upcoming" }
    /// 查詢參數：可指定頁數與 ISO 3166-1 區域碼
    var parameters: [String: String] {
        var params: [String: String] = [:]
        if let page {
            params["page"] = String(page)
        }
        if let region {
            params["region"] = region
        }
        return params
    }
}

/// 取得現正上映電影清單
struct NowPlayingMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    let page: Int?
    let region: String?

    init(page: Int? = nil, region: String? = nil) {
        self.page = page
        self.region = region
    }

    /// `/movie/now_playing`
    var path: String { "/movie/now_playing" }
    /// 查詢參數：可指定頁數與 ISO 3166-1 區域碼
    var parameters: [String: String] {
        var params: [String: String] = [:]
        if let page {
            params["page"] = String(page)
        }
        if let region {
            params["region"] = region
        }
        return params
    }
}

/// 取得相似電影清單
struct SimilarMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    let id: Int
    let page: Int?

    init(id: Int, page: Int? = nil) {
        self.id = id
        self.page = page
    }

    /// `/movie/{movie_id}/similar`
    var path: String { "/movie/\(id)/similar" }
    /// 查詢參數：可指定頁數
    var parameters: [String: String] {
        guard let page else { return [:] }
        return ["page": String(page)]
    }
}
