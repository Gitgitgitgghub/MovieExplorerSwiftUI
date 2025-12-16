//
//  LoadingStateHelpers.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/16.
//

import Foundation

/// 具備 `LoadingState` 的型別介面（通常是 ViewModel）。
@MainActor
protocol LoadingStateProviding: AnyObject {
    /// 目前載入狀態（用於驅動 UI 的 loading / error 呈現）
    var loadingState: LoadingState { get set }
}

extension LoadingStateProviding {

    /// 以共用流程執行非同步工作：自動切換 `loadingState`，並在失敗時轉為 `.failed`。
    ///
    /// - Parameters:
    ///   - successState: 成功後要設定的狀態（預設 `.loaded`，登入等流程可改用 `.idle`）
    ///   - onError: 失敗時額外處理（例如清空資料）
    ///   - operation: 會丟出錯誤的非同步工作
    func withLoadingState(
        successState: LoadingState = .loaded,
        onError: ((Error) -> Void)? = nil,
        operation: () async throws -> Void
    ) async {
        loadingState = .loading
        do {
            try await operation()
            loadingState = successState
        } catch {
            onError?(error)
            loadingState = .failed(message: error.localizedDescription)
        }
    }
}

/// 以 closure 控制外部狀態的 helper（適用於 View 的 `@State` 等情境）。
@MainActor
func withLoadingState(
    setState: (LoadingState) -> Void,
    successState: LoadingState = .loaded,
    onError: ((Error) -> Void)? = nil,
    operation: () async throws -> Void
) async {
    setState(.loading)
    do {
        try await operation()
        setState(successState)
    } catch {
        onError?(error)
        setState(.failed(message: error.localizedDescription))
    }
}

