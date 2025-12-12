//
//  Search.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

/// 搜尋電影（可依關鍵字模糊匹配）
struct SearchMovies: TMDBEndpointProtocol {
    typealias Response = MovieResponse

    let query: String
    let page: Int?
    let includeAdult: Bool
    let region: String?
    let year: Int?
    let primaryReleaseYear: Int?

    init(
        query: String,
        page: Int? = nil,
        includeAdult: Bool = false,
        region: String? = nil,
        year: Int? = nil,
        primaryReleaseYear: Int? = nil
    ) {
        self.query = query
        self.page = page
        self.includeAdult = includeAdult
        self.region = region
        self.year = year
        self.primaryReleaseYear = primaryReleaseYear
    }

    /// `/search/movie`
    var path: String { "/search/movie" }
    /// 查詢參數：關鍵字、頁數、成人內容、區域、年份
    var parameters: [String: String] {
        var params: [String: String] = [
            "query": query,
            "include_adult": includeAdult.description
        ]
        if let page {
            params["page"] = String(page)
        }
        if let region {
            params["region"] = region
        }
        if let year {
            params["year"] = String(year)
        }
        if let primaryReleaseYear {
            params["primary_release_year"] = String(primaryReleaseYear)
        }
        return params
    }
}
