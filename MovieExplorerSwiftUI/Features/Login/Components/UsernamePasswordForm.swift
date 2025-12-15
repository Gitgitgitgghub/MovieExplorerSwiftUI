//
//  UsernamePasswordForm.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/15.
//

import SwiftUI

/// TMDB 使用者名稱/密碼登入表單（提供基本輸入欄位）
struct UsernamePasswordForm: View {

    /// TMDB 使用者名稱（非 email）
    @Binding var username: String
    /// TMDB 密碼（僅用於本次登入，不應持久化）
    @Binding var password: String

    /// 帳密輸入表單內容
    var body: some View {
        Group {
            TextField(text: trimmedUsernameBinding) {
                Text("TMDB Username")
                    .foregroundColor(AppColor.mutedText)
                    .font(.caption)
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .padding()
            .background(AppColor.surface)
            .cornerRadius(10)
            .padding(.horizontal, 16)

            SecureField(text: $password) {
                Text("TMDB Password")
                    .foregroundColor(AppColor.mutedText)
                    .font(.caption)
            }
            .padding()
            .background(AppColor.surface)
            .cornerRadius(10)
            .padding(.horizontal, 16)
        }
    }

    /// 去除前後空白後的 TMDB 使用者名稱 Binding（避免 UI 與送出時出現多餘空白）
    private var trimmedUsernameBinding: Binding<String> {
        Binding(
            get: { username },
            set: { newValue in
                username = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        )
    }
}

#Preview {
    @Previewable @State var username: String = ""
    @Previewable @State var password: String = ""

    return VStack(spacing: 12) {
        UsernamePasswordForm(username: $username, password: $password)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .appBackground()
}
