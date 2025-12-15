# Service 變更同步與 API 註解範例

## 強制同步規則
- 只要 `Core/Service/` 內的程式（含 `TMDBService.swift`、`TMDBEndpointProtocol.swift`、`Endpoints/` 下的端點等）有新增、調整或刪除，務必同時更新 `MovieExplorerSwiftUI/Docs/API_REFERENCE.md`，保持路徑、認證方式、參數、回應型別一致。
- 若改動涉及認證模式（Bearer vs api_key）、預設語系或查詢參數預設值，也要同步補充「通用行為」區段的描述。
- PR 說明需附上「已同步 API_REFERENCE.md」的註記，避免遺漏。

## API 端點說明範例（請依此格式撰寫）
```
### FooBarMovies
- 路徑：`GET /movie/foobar`
- 認證：沿用 TMDBService 預設（Bearer 或 api_key）。
- 參數：
  - `page` (Int?, 選填)：分頁索引。
  - `region` (String?, 選填)：ISO 3166-1 區域碼。
- 回應：`MovieResponse`（FooBar 演算法排序的電影清單）。
```
> 實務指引：標題使用端點型別名稱；明確列出 HTTP 方法與完整路徑；認證若覆寫請註明；參數逐一描述型別、是否必填與用途；回應寫對應的模型名稱與用途簡述。
