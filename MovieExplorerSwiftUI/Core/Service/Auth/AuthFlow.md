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
   - 成功後回傳 `AuthResult`，`AuthStore.update` 設定 `sessionID`，並將 `session_id` 寫入 Keychain 以維持跨重啟登入狀態。

5. **全局狀態與導航**
   - `AuthStore` 為單例（以 `@StateObject` 在 App 初始化），App 依 `authStore.isAuthenticated` 切換登入/主畫面。
   - App 啟動時 `AuthStore` 會嘗試從 Keychain 還原身分（優先登入 session，其次訪客 session）。
   - 若交換失敗，`AuthStore.setError` 紀錄錯誤訊息，LoginPage 顯示於底部 overlay。

### Session 持久化（Keychain）
> 目標：維持跨重啟登入；避免把憑證存入 `UserDefaults`。

- **登入身分**：保存 `session_id`（v3 session）於 Keychain。
- **訪客身分**：保存 `guest_session_id` 與 `expires_at`（若可解析）於 Keychain。
- **還原優先序**：`session_id` 優先於 `guest_session_id`（避免同時存在時身分混亂）。
- **不使用 UserDefaults 的原因**：`session_id`/`guest_session_id` 屬於可代表使用者身分的憑證，應使用 Keychain 提供較佳的系統級保護與存取控制。
- **相關元件**：`AuthCredentialStore`（介面）與 `AuthKeychainStore`（實作）。

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

### 訪客 session 失效處理（退回登入頁）
- App 回到前景（`scenePhase == .active`）時，會呼叫 `AuthStore.invalidateGuestSessionIfExpired()`。
- 若 `expires_at` 已過期：清除 Keychain 內的訪客憑證並重置為 `.anonymous`，UI 會切回 `LoginPage`。
- 若 `expires_at` 無法解析：先照常使用；一旦 API 回應無效 session（例如 401），建議在呼叫端改為觸發 `reset()/clearGuestSession()` 後再引導使用者重新建立訪客 session。

### 登出（清除憑證並回到登入頁）
- `SettingPage` 的「登出」按鈕會呼叫 `AuthStore.logout()`。
- `logout()` 會清除 Keychain 內的登入/訪客憑證並重置 `identity = .anonymous`，UI 會切回 `LoginPage`。

### 狀態機與事件（何時進主畫面/退回登入頁）

#### 狀態定義
- `anonymous`：未授權（顯示 `LoginPage`）。
- `loggedIn(sessionID)`：已登入（顯示 `MainTabPage`）。
- `guest(guestSessionID, expiresAt)`：訪客（未過期時顯示 `MainTabPage`；過期視為未授權）。

#### Root View 判斷規則（是否直接進主畫面）
- App 入口以 `authStore.isAuthenticated` 決定畫面：
  - `true` → `MainTabPage`
  - `false` → `LoginPage`
- `isAuthenticated` 為 `true` 的條件：
  - `identity == .loggedIn(...)` → `true`
  - `identity == .guest(...)` 且 `expiresAt` 未過期或為 `nil` → `true`
  - `identity == .anonymous` 或 `guest` 已過期 → `false`

#### 冷啟動還原規則（為何能「直接進首頁」）
- `AuthStore` 初始化時會從 Keychain 還原身分（優先序如下）：
  1. 有 `session_id` → 還原為 `.loggedIn(sessionID: ...)`
  2. 否則有 `guest_session_id` → 還原為 `.guest(guestSessionID: ..., expiresAt: ...)`
  3. 若 `guest` 讀到 `expiresAt` 且已過期 → 立刻清除訪客憑證並回到 `.anonymous`

#### 事件 → 轉移表
| 事件 | 前置狀態 | 行為（AuthStore / Keychain） | 最終狀態 | UI 結果 |
|---|---|---|---|---|
| 冷啟動 | 任意 | 讀 Keychain：優先 `session_id`，其次 `guest_session_id`；若 guest 過期則清除 | `loggedIn` / `guest` / `anonymous` | 依 `isAuthenticated` 決定進主畫面或登入頁 |
| Web 授權成功 | `anonymous` | `exchangeSession` 成功後 `update(authResult:)`，寫入 `session_id` | `loggedIn` | 進主畫面 |
| 帳密登入成功 | `anonymous` | `createSessionFromLogin` 成功後 `update(authResult:)`，寫入 `session_id` | `loggedIn` | 進主畫面 |
| 訪客登入成功 | `anonymous` | `updateGuest(...)`，寫入 `guest_session_id` + `expires_at` | `guest` | 進主畫面 |
| 回到前景 | `guest` | `invalidateGuestSessionIfExpired()`：若過期則清除訪客憑證並 `reset()` | `guest` 或 `anonymous` | 過期時退回登入頁 |
| 登出 | `loggedIn` / `guest` | `logout()`：清除登入/訪客憑證並 `reset()` | `anonymous` | 退回登入頁 |

### 相關類別與責任
- `AuthService`: 建立授權 URL、解析回呼、交換 session、建立訪客 session。
- `AuthStore`: 持有 `AuthIdentity` 與 `authErrorMessage`，提供登入、訪客登入、回呼處理、登出與重置；並負責 Keychain 還原/保存憑證，且會在訪客過期時視為未授權。
- `AppCoordinator`: 專注於導航狀態（tab、navigation path）與頁面目的地組裝。
- `LoginPage`: 呼叫 `AuthService.authorizationURL()` 開啟授權，顯示錯誤訊息。
- `SettingPage`: 提供登出入口（清除 Keychain 內 session）。

### 測試/除錯建議
- 確認模擬器/裝置已安裝 App，並清除舊版後重跑，確保 URL Scheme 生效。
- 若預覽失敗，為 #Preview 提供 `.environmentObject(AuthStore())` 與 `.environmentObject(AppCoordinator())`。
- 若看到「無效 token」或「網址無效」，先重新取得 request_token、檢查 `redirect_to` 是否正確拼接並與 Info.plist 中的 scheme 一致。
