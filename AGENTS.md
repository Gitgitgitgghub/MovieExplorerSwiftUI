# 儲存庫指南

## 專案結構與模組組織
MovieExplorerSwiftUI 採用功能優先的檔案結構。App 進入點、協調器以及共享的 UI 工具放在 `MovieExplorerSwiftUI/App`。Home、Search、Watchlist 等流程放在 `MovieExplorerSwiftUI/Features/<FeatureName>`。網路客戶端與請求定義位於 `MovieExplorerSwiftUI/Core/API`。DTO 置於 `MovieExplorerSwiftUI/Core/Models`，需符合 `Decodable`，若預覽需要假資料則額外實作 `Mockable`。所有視覺素材集中在 `MovieExplorerSwiftUI/Assets.xcassets`，而 UI 回歸輔助工具與快照檔案放在 `MovieExplorerSwiftUITests`。

## 建置、測試與開發指令
使用 `xcodebuild -scheme MovieExplorerSwiftUI -destination 'generic/platform=iOS' build` 進行編譯，以快速捕捉編譯回歸。推送前執行 `xcodebuild -scheme MovieExplorerSwiftUI -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.4' test`，確保 XCTest（包含非同步網路 stub）在可預期的模擬器中通過。需要互動開發時執行 `xed .` 開啟可編輯的 workspace。預覽與手動測試應依賴 `FakeTMDBService` 或注入本地假資料，避免對實際 API 下請求。

## 程式風格與命名慣例
遵循 Swift 5 預設、四格縮排。型別使用 `UpperCamelCase`，屬性與函式使用 `lowerCamelCase`，全域常數（如 `TMDBConfig.apiKey`）才使用 `SCREAMING_SNAKE_CASE`。讓檔案靠近功能區塊，避免出現龐大的「Common」資料夾，例如可重複使用的輪播元件應放在 `Features/Home/Components/`。僅在需要區分時才為協定名稱加上 `Protocol`（如 `TMDBServiceProtocol`）。非同步函式需命名清楚表意，例如 `loadTrending()`、`refreshWatchlist()`，並偏好在既有型別上擴充而非新增泛用工具檔。

## 測試指南
測試使用 XCTest，命名慣例為 `test<情境>_<預期行為>()`（如 `testTrendingMoviesAPI_ReturnsResults`）。在測試與預覽中總是注入 `FakeTMDBService` 或本地 JSON 假資料，確保結果可重現。提交前務必執行 `xcodebuild … test` 模擬器測試，並為非同步 expectation 加上明確的 timeout 以避免 flake。新增 DTO 時請撰寫簡單的解碼測試以捕捉 schema 變動。

## Commit 與 Pull Request 指南
提交訊息需聚焦且使用祈使語氣（例如 `Add HomeView hero banner`），必要時引用 issue（如 `Fix watchlist sync (#42)`）。Pull Request 描述應概述變更、列出驗證指令，若涉及 UI 則附上截圖或模擬器錄影。若有新增 API、調整 `TMDBConfig`、或加入新的 mock，須在描述中特別標註以提醒審查者。

## 安全與設定提醒
請勿將真實 TMDB API 金鑰提交到版本庫；將其保存於 `APIKey.json` 或安全的環境變數。新增 API endpoint 時需更新 `TMDBConfig`、提供 mock payload，並記錄必要參數。Commit 前檢查 log 與除錯輸出，確保不會洩露憑證或使用者資料。

## 溝通與協作
1. 全程使用繁體中文
2. 禁止無中生有，或做指令以外的事情，若指令不明確應及時向使用者提問

## 文件註解生成指南
- 目標：所有模型（class/struct/enum/變數）需有用途說明；所有方法與計算屬性需有簡潔註解描述行為與回傳值。
- 語言：一律使用繁體中文，保持精準、技術化且易掃描。
- 範圍：僅為模型/計算屬性/方法/變數 撰寫註解；`CodingKeys` 等樣板段落可略過。
- 風格：
- 開頭用簡短句描述用途，避免冗長敘述。
- 若有回傳值或 fallback 行為，簡要說明何時為 nil/空值/預設值。
- enum case 需標註含意與典型使用情境（例如影片類型 Trailer/Teaser 等）。
- 範例：
- `/// TMDB 分頁電影清單回應（含當前頁、總頁數與電影陣列）`
- `/// 海報完整 URL（若無海報則為 nil）`
- `/// 前導預告，時長短、先行曝光`
- 命名：保持與程式碼一致，不改動既有名稱；只透過註解補充語意。
