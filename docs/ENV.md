# 環境與憑證設定指南

## TMDB 憑證
- 檔案：專案根目錄 `APIKey.json`（已加入 `.gitignore`）
- 範例：`APIKey.example.json`
- 格式：
  ```json
  {
    "apiKey": "<TMDB v3 API key>",
    "accessToken": "<TMDB v4 access token，可選>"
  }
  ```
- 用途：
  - v3 `apiKey`：取得 request_token、建立 session（必填）
  - v4 `accessToken`：一般讀取/寫入端點使用的 Bearer token（建議提供）
- CI：建置前從秘密管理載出，寫入 `APIKey.json`。

## URL Scheme / 回呼
- Info.plist 設定了 `movieexplorer` scheme，授權回呼：`movieexplorer://auth/callback`。

## Guest 與登入
- Guest：`/authentication/guest_session/new` 取得 `guest_session_id`（僅能評分）。
- 登入：授權頁 → `request_token` → `CreateSession` 取得 `session_id`（收藏/片單/評分）。
- 登出：`DELETE /authentication/session` 搭配 `session_id`。

更多流程細節請參考 `Core/Service/Auth/AuthFlow.md`。
