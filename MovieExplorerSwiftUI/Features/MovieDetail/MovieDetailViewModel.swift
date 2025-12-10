//
//  MovieDetailViewModel.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/09.
//

import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {

    @Published var detail: MovieDetailResponse?
    @Published var credits: CreditsResponse?
    @Published var loadingState: LoadingState = .idle

    private let movieID: Int
    private let service: TMDBServiceProtocol

    nonisolated init(
        movieID: Int,
        service: TMDBServiceProtocol = TMDBService()
    ) {
        self.movieID = movieID
        self.service = service
    }

    func load() async {
        loadingState = .loading
        do {
            async let detail = service.request(MovieDetails(movieID: movieID))
            async let credits = service.request(MovieCredits(movieID: movieID))
            let (detailResponse, creditsResponse) = try await (detail, credits)
            self.detail = detailResponse
            self.credits = creditsResponse
            loadingState = .loaded
        } catch {
            loadingState = .failed(message: error.localizedDescription)
        }
    }
}

extension MovieDetailViewModel {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded
        case failed(message: String)

        var isLoading: Bool { self == .loading }

        var errorMessage: String? {
            if case let .failed(message) = self {
                return message
            }
            return nil
        }
    }
}
