//
//  HomePageViewModel.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/28.
//

import Foundation

@MainActor
class HomePageViewModel: ObservableObject {
    
    
    //MARK: - Published Properties
    @Published var sections: [Section] = []
    @Published var loadingStatus: LoadingStatus = .idle
    
    private let service: TMDBServiceProtocol
    
    nonisolated init(service: TMDBServiceProtocol = TMDBService()) {
        self.service = service
    }
    
    func load() async {
        loadingStatus = .loading
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

            sections = buildSections(
                trendingResponse: trendingResponse,
                popularResponse: popularResponse,
                topRatedResponse: topRatedResponse,
                nowPlayingResponse: nowPlayingResponse,
                upcomingResponse: upcomingResponse
            )

            loadingStatus = .loaded
        } catch {
            sections = []
            loadingStatus = .failed(message: error.localizedDescription)
        }
        
    }

    private func buildSections(
        trendingResponse: MovieResponse,
        popularResponse: MovieResponse,
        topRatedResponse: MovieResponse,
        nowPlayingResponse: MovieResponse,
        upcomingResponse: MovieResponse
    ) -> [Section] {
        var sections: [Section] = []

        if !trendingResponse.results.isEmpty {
            sections.append(.trending(data: trendingResponse))
        }

        if !popularResponse.results.isEmpty {
            sections.append(.popular(data: popularResponse))
        }

        if !topRatedResponse.results.isEmpty {
            sections.append(.topRated(data: topRatedResponse))
        }

        if !nowPlayingResponse.results.isEmpty {
            sections.append(.nowPlaying(data: nowPlayingResponse))
        }

        if !upcomingResponse.results.isEmpty {
            sections.append(.upcoming(data: upcomingResponse))
        }

        return sections
    }

    //MARK: - Loading Status
    enum LoadingStatus: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)
        
        var isLoading: Bool { self == .loading }
    }
    
    //MARK: Section
    enum Section {
        case trending(data: MovieResponse)
        case popular(data: MovieResponse)
        case topRated(data: MovieResponse)
        case nowPlaying(data: MovieResponse)
        case upcoming(data: MovieResponse)

        var id: String {
            switch self {
            case .trending: return "trending"
            case .popular: return "popular"
            case .topRated: return "topRated"
            case .nowPlaying: return "nowPlaying"
            case .upcoming: return "upcoming"
            }
        }
        
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
