//
//  HomePage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI

struct HomePage: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel = HomePageViewModel()
    
    init(viewModel: HomePageViewModel = HomePageViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.homePath) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    BannerCarousel(
                        items: $viewModel.trending,
                        spacing: 16,
                        cardWidth: 300,
                        cardHeight: 450,
                        swipeThresholdRatio: 0.25
                    ) { item in
                        ZStack(alignment: .bottomLeading) {
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
                                colors: [palette.overlayStart, palette.overlayEnd],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .frame(height: 140)
                            .frame(maxWidth: .infinity, alignment: .bottom)
                            .allowsHitTesting(false)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.title3.weight(.bold))
                                    .foregroundColor(palette.onMediaPrimary)
                                    .lineLimit(2)
                                Text("評分：\(item.voteAverage, specifier: "%.1f")")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(palette.onMediaSecondary)
                            }
                            .padding(8)
                            .padding(12)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: palette.shadow, radius: 8, x: 0, y: 8)
                        .onTapGesture {
                            coordinator.push(.movieDetail(id: item.id))
                        }
                    }
                    sectionHeader(section: .popular)
                    popularMovieRow(
                        movies: viewModel.popular,
                        cardWidth: 200,
                        cardHeight: 300
                    )
                    
                    sectionHeader(section: .nowPlaying)
                    nowPlayingRow()
                    
                    sectionHeader(section: .topRated)
                    topRatedMovieRow(
                        movies: viewModel.topRated,
                        cardWidth: 160,
                        cardHeight: 250
                    )
                    
                    sectionHeader(section: .upcoming)
                    upcomingRow()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.destination(for: route)
            }
            .appBackground()
        }
        .task { await viewModel.load() }
    }
    
    
    private func sectionHeader(section: HomePageViewModel.Section) -> some View {
        Text(section.title)
            .foregroundColor(palette.primaryText)
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
            LazyHStack(spacing: 16) {
                ForEach(movies) { movie in
                    VStack(alignment: .leading, spacing: 8) {
                        posterImage(for: movie)
                            .frame(width: cardWidth, height: cardHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(palette.cardStroke)
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.headline)
                                .foregroundColor(palette.primaryText)
                                .lineLimit(1)
                            Text(String(format: "人氣：%.0f", movie.popularity))
                                .font(.caption.weight(.semibold))
                                .foregroundColor(palette.secondaryText)
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
    private func nowPlayingRow() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(viewModel.nowPlaying) { movie in
                    ZStack(alignment: .bottomLeading) {
                        posterImage(for: movie)
                            .frame(width: 260, height: 360)
                            .overlay(alignment: .bottom){
                                LinearGradient(
                                    colors: [palette.overlayStart, palette.overlayEnd],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                                .frame(maxWidth: .infinity,maxHeight: 140, alignment: .bottom)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .overlay(alignment: .topLeading) {
                                Label("現正上映", systemImage: "play.circle.fill")
                                    .font(.caption2.weight(.bold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.ultraThinMaterial, in: Capsule())
                                    .padding(12)
                            }
                        
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.title3.weight(.bold))
                                .foregroundColor(palette.onMediaPrimary)
                                .lineLimit(2)
                            Text("平均評分 \(movie.ratingText)")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(palette.onMediaSecondary)
                            Text("票房熱度 \(Int(movie.popularity))")
                                .font(.caption2.weight(.semibold))
                                .foregroundColor(palette.onMediaSecondary)
                        }
                        .padding(16)
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
    private func upcomingRow() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(viewModel.upcoming) { movie in
                    VStack(alignment: .leading, spacing: 12) {
                        ZStack(alignment: .topLeading) {
                            posterImage(for: movie)
                                .frame(width: 240, height: 320)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            
                            Text("上映：\(releaseDateText(for: movie))")
                                .font(.caption.weight(.heavy))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial, in: Capsule())
                                .padding(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.headline)
                                .foregroundColor(palette.primaryText)
                                .lineLimit(2)
                            Text(movie.overview)
                                .font(.caption)
                                .foregroundColor(palette.secondaryText)
                                .lineLimit(3)
                        }
                        .padding(.horizontal, 4)
                        
                        Label("加入片單提醒", systemImage: "bell")
                            .font(.caption.weight(.bold))
                            .foregroundColor(palette.primaryText)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(palette.badgeBackground, in: Capsule())
                    }
                    .frame(width: 240, alignment: .leading)
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
            LazyHStack(spacing: 16) {
                ForEach(movies) { movie in
                    VStack(alignment: .leading, spacing: 8) {
                        posterImage(for: movie)
                            .frame(width: cardWidth, height: cardHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(palette.cardStroke)
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.headline)
                                .foregroundColor(palette.primaryText)
                                .lineLimit(1)
                            Text(String(format: "⭐️ %.1f", movie.voteAverage))
                                .font(.caption)
                                .foregroundColor(palette.secondaryText)
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

    @ViewBuilder
    private func posterImage(for movie: Movie) -> some View {
        AsyncImage(url: movie.posterURL) { phase in
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
    }

    private func releaseDateText(for movie: Movie) -> String {
        guard let releaseDate = movie.releaseDate else {
            return "日期待定"
        }
        if let date = Self.releaseDateFormatter.date(from: releaseDate) {
            return Self.releaseDateDisplayFormatter.string(from: date)
        }
        return releaseDate
    }

    private static let releaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private static let releaseDateDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "M月d日"
        return formatter
    }()
    
}

private extension HomePage {
    var palette: AppColor.Palette {
        AppColor.palette(for: colorScheme)
    }
}

#Preview {
    HomePage(viewModel: HomePageViewModel(service: FakeTMDBService()))
        .environmentObject(AppCoordinator())
}
