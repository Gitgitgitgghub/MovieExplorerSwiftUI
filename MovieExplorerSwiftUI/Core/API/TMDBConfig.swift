//
//  TMDBConfig.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

final class TMDBConfig {
    private static let apiKeyResourceName = "APIKey"
    private static let apiKeyResourceExtension = "json"

    /// Reads the API key from `APIKey.json` bundled with the application.
    static let apiKey: String = {
        do {
            return try loadAPIKey()
        } catch {
            fatalError("Failed to load TMDB apiKey: \(error.localizedDescription)")
        }
    }()

    static let baseURL = "https://api.themoviedb.org/3"
    static let posterBaseURL = "https://image.tmdb.org/t/p/w500"
    static let backdropBaseURL = "https://image.tmdb.org/t/p/w780"

    static func loadAPIKey(using bundle: Bundle = .main) throws -> String {
        guard let fileURL = bundle.url(forResource: apiKeyResourceName, withExtension: apiKeyResourceExtension) else {
            throw APIKeyLoadingError.missingFile
        }
        return try loadAPIKey(from: fileURL)
    }

    static func loadAPIKey(from fileURL: URL) throws -> String {
        let data = try Data(contentsOf: fileURL)
        let payload = try JSONDecoder().decode(APIKeyPayload.self, from: data)
        guard !payload.apiKey.isEmpty else {
            throw APIKeyLoadingError.emptyKey
        }
        return payload.apiKey
    }
}

extension TMDBConfig {
    enum APIKeyLoadingError: LocalizedError {
        case missingFile
        case emptyKey

        var errorDescription: String? {
            switch self {
            case .missingFile:
                return "APIKey.json not found in bundle."
            case .emptyKey:
                return "API key in APIKey.json is empty."
            }
        }
    }

    private struct APIKeyPayload: Decodable {
        let apiKey: String
    }
}
