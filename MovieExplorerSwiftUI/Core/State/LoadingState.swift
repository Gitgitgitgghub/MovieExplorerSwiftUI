//
//  LoadingState.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/16.
//

import Foundation

/// UI 載入狀態：用於統一描述頁面或動作的非同步進度與錯誤。
///
/// - Note: 建議由 ViewModel 或 View 的 `@State` 持有，並透過 `isLoading` / `errorMessage` 驅動 UI。
enum LoadingState: Equatable {
    /// 尚未開始載入（初始狀態）
    case idle
    /// 載入中（可用於顯示 overlay / disable 互動）
    case loading
    /// 載入成功完成（資料已就緒）
    case loaded
    /// 載入失敗（提供可顯示給使用者的訊息）
    case failed(message: String)

    /// 是否正在載入中。
    var isLoading: Bool { self == .loading }

    /// 失敗訊息（非失敗狀態時回傳 nil）。
    var errorMessage: String? {
        if case let .failed(message) = self { return message }
        return nil
    }
}

