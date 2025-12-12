## TMDB 授權登入流程說明

### 前置條件
- `APIKey.json` 需包含有效的 `apiKey`（v3）與可選 `accessToken`（v4）。
- App 的 Info.plist 已註冊 URL Scheme：`movieexplorer://auth/callback`。
- `AuthStore`/`AuthService`/`AppCoordinator` 透過依賴注入共享同一個 `AuthStore`。

### 流程步驟
1. **啟動授權**
   - `LoginPage.startTMDBAuthorization()` 呼叫 `AuthService.authorizationURL()`。
   - `AuthService` 先用 API Key 取得 `request_token`（TMDB: https://developer.themoviedb.org/reference/authentication-create-request-token），組合授權網址：
     ```
     https://www.themoviedb.org/authenticate/{request_token}?redirect_to=movieexplorer://auth/callback
     ```
   - 使用 `openURL` 開啟授權頁。

2. **使用者授權**
   - 使用者在 TMDB 頁面點選「允許」，TMDB 以 `redirect_to` 回到 App：
     ```
     movieexplorer://auth/callback?request_token=...&approved=true
     ```

3. **處理回呼**
   - `MovieExplorerSwiftUIApp` 的 `.onOpenURL` 呼叫 `AppCoordinator.handleAuthCallback(url:)`。
   - `AppCoordinator` 使用 `AuthService.parseCallback` 解析參數；若 `approved` 為 true，呼叫 `exchangeSession`。

4. **交換 session**
   - `AuthService.exchangeSession` 以 API Key POST `/authentication/session/new`（TMDB: https://developer.themoviedb.org/reference/authentication-create-session），取得 `session_id`。
   - 成功後回傳 `AuthResult`，`AuthStore.update` 設定 `sessionID` 並標記 `isAuthenticated = true`。

5. **全局狀態與導航**
   - `AuthStore` 為單例（以 `@StateObject` 在 App 初始化），`AppCoordinator` 讀取 `authStore.isAuthenticated` 切換登入/主畫面。
   - 若交換失敗，`AuthStore.setError` 紀錄錯誤訊息，LoginPage 顯示於底部 overlay。

### 相關類別與責任
- `AuthService`: 建立授權 URL、解析回呼、交換 session。
- `AuthStore`: 持有 `isAuthenticated`、`sessionID`、`authErrorMessage`，提供 update/reset。
- `AppCoordinator`: 處理 URL 回呼，成功時更新 `AuthStore` 並切換 tab；其餘導航職責不變。
- `LoginPage`: 呼叫 `AuthService.authorizationURL()` 開啟授權，顯示錯誤訊息。

### 測試/除錯建議
- 確認模擬器/裝置已安裝 App，並清除舊版後重跑，確保 URL Scheme 生效。
- 若預覽失敗，為 #Preview 提供 `.environmentObject(AuthStore())` 與 `.environmentObject(AppCoordinator(authStore: ...))`。
- 若看到「無效 token」或「網址無效」，先重新取得 request_token、檢查 `redirect_to` 是否正確拼接並與 Info.plist 中的 scheme 一致。
