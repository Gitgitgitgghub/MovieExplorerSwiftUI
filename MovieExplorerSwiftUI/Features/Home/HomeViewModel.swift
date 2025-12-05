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
    @Published var nowPlaying: [Movie] = []
    @Published var upcoming: [Movie] = []
    @Published var sections: [Section] = [.trending, .popular, .nowPlaying, .topRated, .upcoming]
    
    private let service: TMDBServiceProtocol
    
    nonisolated init(service: TMDBServiceProtocol = TMDBService()) {
        self.service = service
    }
    
    func load() async {
        do {
            async let t = service.request(TrendingMovies())
            async let p = service.request(PopularMovies())
            async let r = service.request(TopRatedMovies())
            async let n = service.request(NowPlayingMovies())
            async let u = service.request(UpcomingMovies())
            
            let (trendingResponse,
                 popularResponse,
                 topRatedResponse,
                 nowPlayingResponse,
                 upcomingResponse) = try await (t, p, r, n, u)
            
            trending = trendingResponse.results
            popular = popularResponse.results
            topRated = topRatedResponse.results
            nowPlaying = nowPlayingResponse.results
            upcoming = upcomingResponse.results
        } catch {
            
        }
        
    }
    
    //MARK: Section
    enum Section {
        case trending
        case popular
        case topRated
        case nowPlaying
        case upcoming
        
        var title: String {
            switch self {
            case .topRated:
                return "最高評分的電影"
            case .popular:
                return "最受歡迎的電影"
            case .nowPlaying:
                return "現正熱映"
            case .upcoming:
                return "即將上映"
            case .trending:
                return "今日話題焦點"
            }
        }
    }
    
}
