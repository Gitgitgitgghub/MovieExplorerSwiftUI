//
//  HomeView.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/11/27.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject var viewModel = HomeViewModel()
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.homePath) {
            ScrollView {
                LazyVStack(alignment: .leading) {
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
                                colors: [.black.opacity(0.85), .clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .frame(height: 140)
                            .frame(maxWidth: .infinity, alignment: .bottom)
                            .allowsHitTesting(false)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.title3.weight(.bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                Text("評分：\(item.voteAverage, specifier: "%.1f")")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.white.opacity(0.85))
                            }
                            .padding(8)
                            .padding(12)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 8)
                        .onTapGesture {
                            coordinator.push(.movieDetail(id: item.id))
                        }
                    }
                    // popular
                    sectionHeader(section: .popular)
                        .padding(.top, 24)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(viewModel.popular) { movie in
                                VStack(alignment: .leading, spacing: 8) {
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
                                    .frame(width: 100 * 2, height: 100 * 3)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    VStack(alignment: .leading) {
                                        Text(movie.title)
                                            .font(.title3.weight(.bold))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        Text(String(format: "人氣：%.0f", movie.popularity))
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 4)
                                }
                                .onTapGesture {
                                    coordinator.push(.movieDetail(id: movie.id))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    // top rated
                    sectionHeader(section: .topRated)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(viewModel.popular) { movie in
                                VStack(alignment: .leading, spacing: 8) {
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
                                    .frame(width: 70 * 2, height: 70 * 3)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    VStack(alignment: .leading) {
                                        Text(movie.title)
                                            .font(.title3.weight(.bold))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        Text(String(format: "⭐️ %.1f", movie.voteAverage))
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 4)
                                }
                                .onTapGesture {
                                    coordinator.push(.movieDetail(id: movie.id))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.destination(for: route)
            }
            .appBackground()
        }
        .task { await viewModel.load() }
    }
    
    
    func sectionHeader(section: HomeViewModel.Section) -> some View {
        Text(section.title)
            .foregroundColor(.white)
            .font(.title.weight(.bold))
            .padding(.horizontal, 16)
    }
    
}


#Preview {
    HomeView(viewModel: HomeViewModel(service: FakeTMDBService()))
        .environmentObject(AppCoordinator())
}
