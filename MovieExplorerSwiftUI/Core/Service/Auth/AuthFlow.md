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
   - `MovieExplorerSwiftUIApp` 的 `.onOpenURL` 呼叫 `AuthStore.handleAuthCallback(url:)`。
   - `AuthStore` 使用 `AuthService.parseCallback` 解析參數；若 `approved` 為 true，呼叫 `exchangeSession`。

4. **交換 session**
   - `AuthService.exchangeSession` 以 API Key POST `/authentication/session/new`（TMDB: https://developer.themoviedb.org/reference/authentication-create-session），取得 `session_id`。
   - 成功後回傳 `AuthResult`，`AuthStore.update` 設定 `sessionID` 並標記 `isAuthenticated = true`。

5. **全局狀態與導航**
   - `AuthStore` 為單例（以 `@StateObject` 在 App 初始化），App 依 `authStore.isAuthenticated` 切換登入/主畫面。
   - 若交換失敗，`AuthStore.setError` 紀錄錯誤訊息，LoginPage 顯示於底部 overlay。

### 替代流程：App 內帳密登入（Create Session from Login）
> 注意：TMDB 官方建議優先使用 Web 授權頁流程；帳密登入僅用於特定需求，且**不應持久化**使用者密碼。

1. `LoginPage` 輸入 `username/password`，呼叫 `AuthStore.loginWithTMDBCredentials`。
2. `AuthStore.loginWithTMDBCredentials` 內部呼叫 `AuthService.createSessionFromLogin`，並依序執行：
   - `GET /authentication/token/new` 取得 `request_token`
   - `POST /authentication/token/validate_with_login` 驗證 `request_token`
   - `POST /authentication/session/new` 交換為 `session_id`
3. 成功後 `AuthStore.update(authResult:)` 更新為 `.loggedIn(sessionID:...)`，UI 依 `isAuthenticated` 進入主畫面。

### 替代流程：訪客登入（Guest Session）
> 注意：訪客登入會取得 `guest_session_id`，通常僅能使用受限功能（例如評分），不具備帳號層級的個人化資料能力

1. `LoginPage` 點選「訪客登入」，呼叫 `AuthStore.loginAsGuest()`。
2. `AuthStore.loginAsGuest()` 內部呼叫 `AuthService.createGuestSession()`：
   - `GET /authentication/guest_session/new` 取得 `guest_session_id` 與 `expires_at`
3. 成功後 `AuthStore.updateGuest(sessionID:expiresAt:)` 更新為 `.guest(guestSessionID:expiresAt:)`，UI 依 `isAuthenticated` 進入主畫面。
4. 若建立失敗，`AuthStore.setError` 紀錄錯誤訊息，LoginPage 顯示於底部 overlay。

### 相關類別與責任
- `AuthService`: 建立授權 URL、解析回呼、交換 session、建立訪客 session。
- `AuthStore`: 持有 `AuthIdentity` 與 `authErrorMessage`，並提供登入、訪客登入、回呼處理與重置；`isAuthenticated` 會在 `.loggedIn` 與 `.guest` 時為 true。
- `AppCoordinator`: 專注於導航狀態（tab、navigation path）與頁面目的地組裝。
- `LoginPage`: 呼叫 `AuthService.authorizationURL()` 開啟授權，顯示錯誤訊息。

### 測試/除錯建議
- 確認模擬器/裝置已安裝 App，並清除舊版後重跑，確保 URL Scheme 生效。
- 若預覽失敗，為 #Preview 提供 `.environmentObject(AuthStore())` 與 `.environmentObject(AppCoordinator())`。
- 若看到「無效 token」或「網址無效」，先重新取得 request_token、檢查 `redirect_to` 是否正確拼接並與 Info.plist 中的 scheme 一致。
