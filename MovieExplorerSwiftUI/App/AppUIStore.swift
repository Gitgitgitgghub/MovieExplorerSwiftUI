//
//  AppUIStore.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/17.
//

import Foundation

/// App 全域 UI 狀態（用於跨頁提示，例如授權回呼錯誤或通用錯誤對話框）。
@MainActor
final class AppUIStore: ObservableObject {

    /// App 全域提示模型（用於跨頁事件的錯誤/提醒，例如授權回呼失敗）。
    struct Alert: Identifiable, Equatable {
        /// 提示識別值（用於 SwiftUI 更新）
        let id: UUID = UUID()
        /// 標題
        let title: String
        /// 內容訊息
        let message: String
    }

    /// 目前要顯示的全域提示（nil 表示不顯示）。
    @Published var alert: Alert?

    /// 顯示提示。
    /// - Parameters:
    ///   - title: 標題
    ///   - message: 內容
    func showAlert(title: String, message: String) {
        alert = Alert(title: title, message: message)
    }

    /// 顯示錯誤提示（使用預設標題）。
    /// - Parameter message: 錯誤內容
    func showError(_ message: String) {
        showAlert(title: "發生錯誤", message: message)
    }

    /// 關閉目前提示。
    func dismissAlert() {
        alert = nil
    }
}
