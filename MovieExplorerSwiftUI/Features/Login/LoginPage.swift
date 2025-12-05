//
//  LoginPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/1.
//

import SwiftUI

struct LoginPage: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: LoginPageViewModel
    
    init(viewModel: LoginPageViewModel = LoginPageViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Welcome back")
                .font(.title)
                .bold()
                .foregroundColor(palette.mutedText)
            TextField(text: $viewModel.email) {
                Text("Email")
                    .foregroundColor(palette.mutedText)
            }
            .padding()
            .background(palette.surface)
            .cornerRadius(10)
            .padding(.horizontal, 16)
            SecureField(text: $viewModel.password) {
                Text("Password")
                    .foregroundColor(palette.mutedText)
            }
            .padding()
            .background(palette.surface)
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
                    .background(palette.accent)
                    .clipShape(.capsule)
            }
            .padding(.init(top: 32, leading: 16, bottom: 0, trailing: 16))
            divider
                .padding(.top, 32)
            HStack(spacing: 32) {
                Button(action: {
                    
                }) {
                    Image(systemName: "apple.logo")
                        .frame(width: 60, height: 60)
                        .clipShape(.circle)
                        .glassEffect()
                }
                
                Button(action: {
                    
                }) {
                    Image(systemName: "apple.logo")
                        .frame(width: 60, height: 60)
                        .clipShape(.circle)
                        .glassEffect()
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
                .foregroundColor(palette.mutedText)
            Text("Or continue with")
                .foregroundColor(palette.mutedText)
                .lineLimit(1)
                .padding(8)
                .layoutPriority(1)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(palette.mutedText)
        }
        .padding(.horizontal, 16)
    }
}

private extension LoginPage {
    var palette: AppColor.Palette {
        AppColor.palette(for: colorScheme)
    }
}
#Preview {
    LoginPage()
        .environmentObject(AppCoordinator())
}
