//
//  LoginPage.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/1.
//

import SwiftUI

struct LoginPage: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: LoginPageViewModel
    
    init(viewModel: LoginPageViewModel = LoginPageViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Welcome back")
                .font(.title)
                .bold()
                .foregroundColor(AppColor.mutedText)
            TextField(text: $viewModel.email) {
                Text("Email")
                    .foregroundColor(AppColor.mutedText)
            }
            .padding()
            .background(AppColor.surface)
            .cornerRadius(10)
            .padding(.horizontal, 16)
            SecureField(text: $viewModel.password) {
                Text("Password")
                    .foregroundColor(AppColor.mutedText)
            }
            .padding()
            .background(AppColor.surface)
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
                    .background(AppColor.accent)
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
                .foregroundColor(AppColor.mutedText)
            Text("Or continue with")
                .foregroundColor(AppColor.mutedText)
                .lineLimit(1)
                .padding(8)
                .layoutPriority(1)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(AppColor.mutedText)
        }
        .padding(.horizontal, 16)
    }
}
#Preview {
    LoginPage()
        .environmentObject(AppCoordinator())
}
