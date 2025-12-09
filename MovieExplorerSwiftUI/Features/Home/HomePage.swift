//
//  HomePage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI

struct HomePage: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject var viewModel = HomePageViewModel()
    
    init(viewModel: HomePageViewModel = HomePageViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.homePath) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Layout.sectionSpacing) {
                    ForEach(viewModel.sections, id: \.id) { section in
                        sectionView(for: section)
                    }
                }
            }
            .opacity(viewModel.loadingStatus.isLoading ? 0 : 1)
            .disabled(viewModel.loadingStatus.isLoading)
            .animation(.easeInOut(duration: 0.25), value: viewModel.loadingStatus)
            .overlay {
                if viewModel.loadingStatus.isLoading {
                    CinematicLoadingView(
                        title: "正在載入片單",
                        subtitle: "同步趨勢、票房與演員陣容，馬上就好"
                    )
                    .padding(.horizontal, 24)
                    .frame(alignment: .center)
                    .transition(.opacity)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.destination(for: route)
            }
            .appBackground()
        }
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private func sectionView(for section: HomePageViewModel.Section) -> some View {
        switch section {
        case .trending(let response):
            bannerCarousel(movies: response.results)
        case .popular(let response):
            sectionHeader(section: section)
            popularMovieRow(
                movies: response.results,
                cardWidth: Layout.popular.width,
                cardHeight: Layout.popular.height
            )
        case .nowPlaying(let response):
            sectionHeader(section: section)
            nowPlayingRow(movies: response.results)
        case .topRated(let response):
            sectionHeader(section: section)
            topRatedMovieRow(
                movies: response.results,
                cardWidth: Layout.topRated.width,
                cardHeight: Layout.topRated.height
            )
        case .upcoming(let response):
            sectionHeader(section: section)
            upcomingRow(movies: response.results)
        }
    }
    
    private func bannerCarousel(movies: [Movie]) -> some View {
        BannerCarousel(
            items: movies,
            spacing: Layout.bannerSpacing,
            cardWidth: Layout.banner.width,
            cardHeight: Layout.banner.height,
            swipeThresholdRatio: 0.25
        ) { item in
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: item.posterURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Color.gray.opacity(0.3)
                    case .empty:
                        Color.gray.opacity(0.15)
                    @unknown default:
                        Color.gray.opacity(0.15)
                    }
                }
                
                LinearGradient(
                    colors: [AppColor.overlayStart, AppColor.overlayEnd],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 140)
                .frame(maxWidth: .infinity, alignment: .bottom)
                .allowsHitTesting(false)
                Text(String(format: "⭐️  %.1f", item.voteAverage))
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(AppColor.primaryText)
                    .padding(6)
                                .glassEffect()
                                .padding()
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: AppColor.shadow, radius: 8, x: 0, y: 8)
            .onTapGesture {
                coordinator.push(.movieDetail(id: item.id))
            }
        }
    }
    
    
    private func sectionHeader(section: HomePageViewModel.Section) -> some View {
        Text(section.title)
            .foregroundColor(AppColor.primaryText)
            .font(.title.weight(.bold))
            .padding(.horizontal, 16)
    }

        @ViewBuilder
        private func popularMovieRow(
            movies: [Movie],
            cardWidth: CGFloat,
            cardHeight: CGFloat
        ) -> some View {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Layout.popularSpacing) {
                    ForEach(movies) { movie in
                        VStack(alignment: .leading, spacing: 8) {
                        PosterCard(url: movie.posterURL)
                            .frame(width: cardWidth, height: cardHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(AppColor.cardStroke)
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: "人氣：%.0f", movie.popularity))
                                .font(.subheadline.weight(.bold))
                                .foregroundColor(AppColor.secondaryText)
                        }
                    }
                    .padding(.bottom, 4)
                    .onTapGesture {
                        coordinator.push(.movieDetail(id: movie.id))
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func nowPlayingRow(movies: [Movie]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(movies) { movie in
                    VStack(alignment: .leading, spacing: 8) {
                        PosterCard(url: movie.posterURL)
                            .frame(width: Layout.nowPlaying.width, height: Layout.nowPlaying.height)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .overlay(alignment: .topLeading) {
                                Label("現正上映", systemImage: "play.circle.fill")
                                    .font(.caption2.weight(.bold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.ultraThinMaterial, in: Capsule())
                                    .padding(12)
                            }
                        Text("票房熱度: \(Int(movie.popularity))")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(AppColor.secondaryText)
                    }
                    .onTapGesture {
                        coordinator.push(.movieDetail(id: movie.id))
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func upcomingRow(movies: [Movie]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(movies) { movie in
                    VStack(alignment: .leading, spacing: 8) {
                        ZStack(alignment: .topLeading) {
                            PosterCard(url: movie.posterURL)
                                .frame(width: Layout.upcoming.width, height: Layout.upcoming.height)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            
                            Text("上映：\(movie.formattedReleaseDate())")
                                .font(.caption.weight(.heavy))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial, in: Capsule())
                                .padding(12)
                        }
                        HStack(alignment: .center) {
                            Spacer()
                            Label("加入片單提醒", systemImage: "bell")
                                .font(.caption.weight(.bold))
                                .foregroundColor(AppColor.primaryText)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(AppColor.badgeBackground, in: Capsule())
                            Spacer()
                        }
                        
                    }
                    .frame(width: Layout.upcoming.width, alignment: .leading)
                    .padding(.vertical, 8)
                    .onTapGesture {
                        coordinator.push(.movieDetail(id: movie.id))
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func topRatedMovieRow(
        movies: [Movie],
        cardWidth: CGFloat,
        cardHeight: CGFloat
    ) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Layout.topRatedSpacing) {
                ForEach(movies) { movie in
                    VStack(alignment: .leading, spacing: 8) {
                        PosterCard(url: movie.posterURL)
                            .frame(width: cardWidth, height: cardHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(AppColor.cardStroke)
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: "⭐️ %.1f", movie.voteAverage))
                                .font(.subheadline.bold())
                                .foregroundColor(AppColor.secondaryText)
                        }
                    }
                    .frame(width: cardWidth)
                    .padding(.bottom, 4)
                    .onTapGesture {
                        coordinator.push(.movieDetail(id: movie.id))
                    }
                }
            }
            .padding(.horizontal)
        }
    }

}

private enum Layout {
    struct CardSize {
        let width: CGFloat
        let height: CGFloat
    }

    static let sectionSpacing: CGFloat = 24
    static let bannerSpacing: CGFloat = 16

    static let banner = CardSize(width: 300, height: 450)
    static let popular = CardSize(width: 200, height: 300)
    static let topRated = CardSize(width: 160, height: 250)
    static let nowPlaying = CardSize(width: 260, height: 360)
    static let upcoming = CardSize(width: 240, height: 320)

    static let popularSpacing: CGFloat = 16
    static let topRatedSpacing: CGFloat = 16
}

#Preview {
    HomePage(viewModel: HomePageViewModel(service: FakeTMDBService()))
        .environmentObject(AppCoordinator())
}
