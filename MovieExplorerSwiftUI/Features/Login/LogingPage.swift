//
//  LogingPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/1.
//

import SwiftUI

struct LogingPage: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Welcome back")
                .font(.title)
                .bold()
                .foregroundColor(Color.rgb(145, 163, 199))
            TextField(text: $viewModel.email) {
                Text("Email")
                    .foregroundColor(Color.rgb(145, 163, 199))
            }
            .padding()
            .background(Color.rgb(35, 46, 72))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            SecureField(text: $viewModel.password) {
                Text("Password")
                    .foregroundColor(Color.rgb(145, 163, 199))
            }
            .padding()
            .background(Color.rgb(35, 46, 72))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            Button(action: {
                viewModel.login(using: coordinator)
            }) {
                Text("Log in")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.rgb(74, 144, 226))
                    .clipShape(.capsule)
            }
            .padding(.init(top: 32, leading: 16, bottom: 0, trailing: 16))
            divider
                .padding(.top, 32)
            HStack(spacing: 32) {
                Button(action: {
                    
                }) {
                    Image(systemName: "apple.logo")
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(.ultraThinMaterial)
                        .clipShape(.circle)
                }
                
                Button(action: {
                    
                }) {
                    Image(systemName: "apple.logo")
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(.ultraThinMaterial)
                        .clipShape(.circle)
                }
            }
            .padding(.top, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appBackground()
    }
    
    
    private var divider: some View {
        HStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.rgb(145, 163, 199))
            Text("Or continue with")
                .foregroundColor(Color.rgb(145, 163, 199))
                .lineLimit(1)
                .padding(8)
                .layoutPriority(1)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.rgb(145, 163, 199))
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    LogingPage()
        .environmentObject(AppCoordinator())
}
