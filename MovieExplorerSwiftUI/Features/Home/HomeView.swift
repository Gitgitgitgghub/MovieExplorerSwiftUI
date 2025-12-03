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
                
            }
            .appBackground()
            .task { await viewModel.load() }
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.destination(for: route)
            }
        }
    }
    
   
    
    
}


#Preview {
    HomeView(viewModel: HomeViewModel(service: FakeTMDBService()))
        .environmentObject(AppCoordinator())
        .appBackground()
}
