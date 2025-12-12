//
//  MovieVideosResponse.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/12.
//

import Foundation

/// TMDB 單部電影的影片列表回應
struct MovieVideosResponse: Decodable, Mockable {
    let id: Int
    let results: [MovieVideo]
}

/// 單一影片項目（預告、前導、片段等）
struct MovieVideo: Decodable, Identifiable {
    let id: String
    let iso639_1: String?
    let iso3166_1: String?
    let name: String
    let key: String
    let site: String
    let size: Int?
    let type: VideoKind
    let official: Bool?
    let publishedAt: String?

    var youtubeURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }

    var isTrailer: Bool {
        type == .trailer
    }

    /// 影片類型
    enum VideoKind: String, Decodable {
        /// 正式預告，完整呈現主線內容
        case trailer = "Trailer"
        /// 前導預告，時長短、先行曝光
        case teaser = "Teaser"
        /// 影片片段，節錄正式內容
        case clip = "Clip"
        /// 幕後花絮，拍攝或訪談側寫
        case behindTheScenes = "Behind the Scenes"
        /// 特輯，主題式介紹角色或故事
        case featurette = "Featurette"
        /// NG/花絮鏡頭
        case bloopers = "Bloopers"
        /// 片頭片段
        case openingCredits = "Opening Credits"
        case other

        init(from decoder: Decoder) throws {
            let raw = (try? decoder.singleValueContainer().decode(String.self)) ?? ""
            self = VideoKind(rawValue: raw) ?? .other
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name
        case key
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
    }
}

extension MovieVideosResponse {
    var preferredTrailer: MovieVideo? {
        results.first(where: { $0.isTrailer && $0.youtubeURL != nil })
        ?? results.first(where: { $0.youtubeURL != nil })
    }
}

extension MovieVideosResponse {
    static var mockJson: String {
        """
        {
          "id": 1084242,
          "results": [
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Official Trailer",
              "key": "uSM5MpKSnqg",
              "site": "YouTube",
              "size": 1080,
              "type": "Trailer",
              "official": true,
              "published_at": "2024-11-01T15:00:00.000Z",
              "id": "65c3f214936a3e0bf0d4ae10"
            },
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Teaser",
              "key": "1Fq08j0bBXU",
              "site": "YouTube",
              "size": 1080,
              "type": "Teaser",
              "official": true,
              "published_at": "2024-10-15T12:00:00.000Z",
              "id": "65c3f214936a3e0bf0d4ae11"
            }
          ]
        }
        """
    }
}
