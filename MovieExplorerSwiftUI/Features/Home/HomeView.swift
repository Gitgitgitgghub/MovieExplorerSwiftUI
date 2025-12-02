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
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    heroSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 32)
            }
            .appBackground()
            .task { await viewModel.load() }
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.destination(for: route)
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Featured Today")
                .font(.title.bold())
                .foregroundStyle(.white)
            Text("Tap a movie to view details")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var heroSection: some View {
        if let hero = viewModel.trending.first {
            HeroBanner(movie: hero)
                .onTapGesture {
                    coordinator.push(.movieDetail(id: hero.id))
                }
        } else {
            RoundedRectangle(cornerRadius: 32)
                .fill(.white.opacity(0.05))
                .frame(height: 260)
                .overlay {
                    ProgressView()
                        .tint(.white)
                }
        }
    }
}

private struct HeroBanner: View {
    let movie: Movie
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    Color.white.opacity(0.08)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Color.white.opacity(0.08)
                @unknown default:
                    Color.white.opacity(0.08)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            
            LinearGradient(
                colors: [Color.black.opacity(0.9), Color.black.opacity(0)],
                startPoint: .bottom,
                endPoint: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 32))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(2)
            }
            .padding()
        }
        .frame(height: 260)
        .contentShape(RoundedRectangle(cornerRadius: 32))
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(service: FakeTMDBService()))
        .environmentObject(AppCoordinator())
        .appBackground()
}
