//
//  MovieDetailPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI

struct MovieDetailPage: View {
    
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
    @EnvironmentObject private var coordinator: AppCoordinator
    var movieID: Int
    var service: TMDBServiceProtocol
    @State var detail: MovieDetailResponse?
    @State var credits: CreditsResponse?
    @State var loadingState: LoadingState = .idle
    
    init(movieID: Int, service: TMDBServiceProtocol = TMDBService()) {
        self.movieID = movieID
        self.service = service
    }

    var body: some View {
        ScrollView {
            if let detail = detail {
                VStack(spacing: 16) {
                    heroSection(detail: detail)
                    StatCardsSectionView(detail: detail)
                    OverviewSectionView(detail: detail)
                    GenresSectionView(detail: detail)
                    CastSectionView(credits: credits) {
                        coordinator.push(.actorDetail(id: $0))
                    }
                }
                .padding(.bottom, 28)
            }
        }
        .scrollIndicators(.hidden)
        .overlay { loadingUI }
        .animation(.easeInOut(duration: 0.25), value: loadingState)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(detail?.title ?? "電影詳情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let detail = detail {
                    Menu {
                        if let homepage = detail.homepage, let url = URL(string: homepage) {
                            Link(destination: url) {
                                Label("官方網站", systemImage: "link")
                            }
                        }
                        Button {
                            // 預留收藏或提醒功能
                        } label: {
                            Label("加入片單", systemImage: "bookmark.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(AppColor.primaryText)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .appBackground()
        .task { await load() }
    }

    // MARK: - Loading / Error
    @ViewBuilder
    private var loadingUI: some View {
        switch loadingState {
        case .loading:
            CinematicLoadingView(
                title: "正在載入電影細節",
                subtitle: "同步劇情、卡司與官方資訊"
            )
            .padding(.horizontal, 32)
            .transition(.opacity)
        case .failed(let message):
            CinematicErrorView(
                title: "載入失敗",
                message: message,
                retryTitle: "重新整理",
                onRetry: { Task { await load() } }
            )
            .padding(.horizontal, 24)
            .transition(.opacity)
        default:
            EmptyView()
        }
    }

    // MARK: - Sections
    private func heroSection(detail: MovieDetailResponse) -> some View {
        PosterCard(url: detail.backdropURL ?? detail.posterURL)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, 16)
        .shadow(color: AppColor.shadow.opacity(0.35), radius: 16, x: 0, y: 12)
    }
    
}

// MARK: - MovieDetailPage 主要方法區
extension MovieDetailPage {
    
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


#Preview {
    NavigationStack {
        MovieDetailPage(
            movieID: 1084242,
            service: FakeTMDBService())
        .preferredColorScheme(.dark)
    }
}
