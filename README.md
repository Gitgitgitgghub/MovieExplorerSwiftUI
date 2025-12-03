# MovieExplorerSwiftUI

MovieExplorerSwiftUI 是一個使用 SwiftUI + async/await 打造的 TMDB（The Movie Database）電影探索 App。UI 以 feature-first 架構拆分 (`Features/Home`, `Features/Search` 等)，並透過共用的 `TMDBService` 與 `TMDBEndpoint` 封裝 API 邏輯。建置時也會在背景呼叫 `/configuration` API，確保影像 baseURL / size 與 TMDB 後台同步。

## 系統需求
- macOS 14.4+ 搭配 Xcode 16.4（含 iOS 17.4 SDK）
- Swift 5.10 toolchain
- TMDB API key（放在專案根目錄 `APIKey.json`，如下節）

## 專案結構
| 路徑 | 說明 |
| --- | --- |
| `MovieExplorerSwiftUI/App` | App 生命週期與 `AppCoordinator` |
| `MovieExplorerSwiftUI/Core/API` | `TMDBService`, `TMDBEndpoint`、`TMDBConfigurationLoader` 等 API 基礎設施 |
| `MovieExplorerSwiftUI/Core/Models` | DTO，例如 `MovieResponse`, `ConfigurationDetailsResponse` |
| `MovieExplorerSwiftUI/Features/*` | 依功能切分的 SwiftUI 畫面與 ViewModel |
| `MovieExplorerSwiftUITests` | XCTest 測試，含串接 TMDB API 的 smoke tests |

開發時可透過 `FakeTMDBService` 注入 mock data，所有 `Mockable` 模型都能直接在 Preview 中顯示假資料。

## TMDB API Key 設定
專案根目錄需要一份 `APIKey.json`，內容如下：

```json
{
  "apiKey": "<你的 TMDB API key>"
}
```

- `APIKey.json` 已納入 `.gitignore`，請勿將真實 Key 提交到 Git。
- 未提供檔案時，`TMDBConfig` 在初始化會直接 `fatalError`。
- CI / 自動化環境可於建置前動態生成 `APIKey.json`（例如從秘密儲存解密後寫入）。

## 建置與測試
```bash
# 建置 iOS App（generic iOS 裝置）
xcodebuild -scheme MovieExplorerSwiftUI \
  -destination 'generic/platform=iOS' build

# 在 iPhone 17 Pro (iOS 26.1) 模擬器上執行測試
xcodebuild -scheme MovieExplorerSwiftUI \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.1' test
```

> 若 CI 或本機找不到指定模擬器，可先在 Xcode > Settings > Platforms 下載對應 runtime，或改用 `platform=iOS Simulator,name=Any iOS Simulator Device`。

## Configuration API 與影像設定
App 啟動後會透過 `TMDBConfigurationLoader` 呼叫 [TMDB Configuration Details](https://developer.themoviedb.org/reference/configuration-details) API，並更新 `TMDBConfig` 內的 `posterBaseURL` / `backdropBaseURL`。這能確保圖片尺寸、base URL 永遠與 TMDB 後台同步，也避免硬編碼路徑過期。

若需在其他模組使用相同資料，可直接呼叫：

```swift
await TMDBConfigurationLoader.shared.loadIfNeeded()
let posterURL = TMDBConfig.posterBaseURL
```

## 問題排查
- **App 啟動閃退**：確認 `APIKey.json` 是否存在，且 `apiKey` 不為空字串。
- **TMDB API 錯誤**：請檢查 `.env` / CI Secret 中的 TMDB Key 是否過期，或 TMDB 是否封鎖來源 IP。
- **模擬器找不到**：執行 `xcrun simctl list runtimes` 確認 runtime 是否有 iOS 26.1，再透過 `xcode-select` 切換正確 Xcode。

歡迎提交 Issue / PR，一起讓 MovieExplorerSwiftUI 更完善 🎬
