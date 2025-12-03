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
    private static var imageConfiguration = TMDBImageConfiguration.fallback
    private static let imageConfigurationLock = NSLock()

    /// Reads the API key from `APIKey.json` bundled with the application.
    static let apiKey: String = {
        do {
            return try loadAPIKey()
        } catch {
            fatalError("Failed to load TMDB apiKey: \(error.localizedDescription)")
        }
    }()

    static let baseURL = "https://api.themoviedb.org/3"

    static var posterBaseURL: String {
        imageConfigurationLock.lock()
        let baseURL = imageConfiguration.posterBaseURL
        imageConfigurationLock.unlock()
        return baseURL
    }

    static var backdropBaseURL: String {
        imageConfigurationLock.lock()
        let baseURL = imageConfiguration.backdropBaseURL
        imageConfigurationLock.unlock()
        return baseURL
    }

    static func updateImageConfiguration(_ configuration: TMDBImageConfiguration) {
        imageConfigurationLock.lock()
        imageConfiguration = configuration
        imageConfigurationLock.unlock()
    }

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
