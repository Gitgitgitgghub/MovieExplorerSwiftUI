# MovieExplorerSwiftUI

## TMDB API Key 設定
- 專案根目錄需要一份 `APIKey.json`，內容格式如下：

```json
{
  "apiKey": "<你的 TMDB API key>"
}
```

- `APIKey.json` 已列入 `.gitignore`，請勿把含有真實 key 的檔案提交到 git。
- 沒有這個檔案時，`TMDBConfig` 會在讀取 apiKey 時觸發錯誤並使 App Crash，請在本地或 CI 環境先建立好。
- 如需在 CI 或其他自動化環境使用，可於建置前動態產生 `APIKey.json`（例如使用安全儲存的密鑰注入）。
