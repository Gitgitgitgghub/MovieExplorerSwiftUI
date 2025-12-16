//
//  MovieDetailPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI

struct MovieDetailPage: View {

    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.openURL) private var openURL
    var movieID: Int
    var service: TMDBServiceProtocol
    @State private var detail: MovieDetailResponse?
    @State private var credits: CreditsResponse?
    @State private var videos: MovieVideosResponse?
    @State private var loadingState: LoadingState = .idle
    @State private var isTrailerPulse = false
    
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
                .frame(maxWidth: .infinity, alignment: .leading)
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
    @ViewBuilder
    private func heroSection(detail: MovieDetailResponse) -> some View {
        PosterCard(url: detail.backdropURL ?? detail.posterURL)
            .aspectRatio(16 / 9, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(alignment: .bottomTrailing) {
                if let trailerURL {
                    Button {
                        openURL(trailerURL)
                    } label: {
                        Label("預告片", systemImage: "play.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(AppColor.primaryText)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .glassEffect()
                            .shadow(color: AppColor.shadow.opacity(0.25), radius: isTrailerPulse ? 14 : 8, x: 0, y: 6)
                    }
                    .scaleEffect(isTrailerPulse ? 1.05 : 1)
                    .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: isTrailerPulse)
                    .onAppear { isTrailerPulse = true }
                    .padding(12)
                }
            }
            .padding(.horizontal, 8)
    }
    
}

// MARK: - MovieDetailPage 主要方法區
extension MovieDetailPage {
    
    private var trailerURL: URL? {
        videos?.preferredTrailer?.youtubeURL
    }
    
    func load() async {
        await withLoadingState(setState: { loadingState = $0 }) {
            async let detail = service.request(MovieDetails(movieID: movieID))
            async let credits = service.request(MovieCredits(movieID: movieID))
            async let videos = service.request(MovieVideos(movieID: movieID))
            let (detailResponse, creditsResponse, videosResponse) = try await (detail, credits, videos)
            self.detail = detailResponse
            self.credits = creditsResponse
            self.videos = videosResponse
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
