//
//  HomeViewModel.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    //MARK: - Published Properties
    @Published var trending: [Movie] = []
    @Published var popular: [Movie] = []
    @Published var topRated: [Movie] = []
    
    private let service: TMDBServiceProtocol
    
    nonisolated init(service: TMDBServiceProtocol = TMDBService()) {
        self.service = service
    }
    
    func load() async {
        do {
            async let t = service.request(TrendingMovies())
            async let p = service.request(PopularMovies())
            async let r = service.request(TopRatedMovies())
            trending = try await t.results
            popular = try await p.results
            topRated = try await r.results
        } catch {
            
        }
        
    }
    
}
