//
//  TMDBConfigurationLoader.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/02.
//

import Foundation

actor TMDBConfigurationLoader {
    
    static let shared = TMDBConfigurationLoader()
    
    private let service: TMDBServiceProtocol
    private var didLoadConfiguration = false
    
    init(service: TMDBServiceProtocol = TMDBService()) {
        self.service = service
    }
    
    func loadIfNeeded() async throws {
        guard !didLoadConfiguration else { return }
        do {
            let response = try await service.request(ConfigurationDetails())
            TMDBConfig.updateImageConfiguration(response.images)
            didLoadConfiguration = true
        } catch {
            throw error
        }
    }
}
