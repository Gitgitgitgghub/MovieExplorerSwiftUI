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
    @Published var sections: [Section] = [.trending, .popular, .topRated]
    
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
    
    //MARK: Section
    enum Section {
        case trending
        case popular
        case topRated
        
        var title: String {
            switch self {
            case .topRated: return "最高評分的電影"
            case .popular: return "最受歡迎的電影"
            default: return ""
            }
        }
    }
    
}
