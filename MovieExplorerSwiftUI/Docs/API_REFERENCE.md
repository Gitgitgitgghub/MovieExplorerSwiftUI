# TMDB API 端點說明

## 通用行為
- 基底網址：`https://api.themoviedb.org/3`
- 語系：`TMDBService` 會在未指定 `language` 時自動帶入 `defaultLanguage`（預設 `en-US`）。
- 認證：
  - 服務初始化會優先使用 `APIKey.json` 的 v4 `accessToken` 以 Bearer Token 發送；若不存在則改用 v3 `apiKey` 置於 query string。
  - `RequestToken` 與 `CreateSession` 明確覆寫為使用 v3 `apiKey` 查詢參數。
- 請求：`TMDBEndpointProtocol` 讓端點宣告 `path`、HTTP 方法、查詢參數、body 與額外標頭，`TMDBService.request` 會組合成完整 `URLRequest`。
- 回應：所有端點以 `JSONDecoder` 解碼為對應的 `Response` 型別；測試/預覽可用 `FakeTMDBService` 直接回傳 `Mockable.mock`。

## 設定
### ConfigurationDetails
- 路徑：`GET /configuration`
- 認證：沿用 `TMDBService` 預設（Bearer 或 api_key）。
- 參數：無額外查詢參數；自動附帶 `language`。
- 回應：`ConfigurationDetailsResponse`（影像基底網址、尺寸列表等設定）。

## 搜尋
### SearchMovies
- 路徑：`GET /search/movie`
- 認證：沿用 `TMDBService` 預設。
- 參數：
  - `query` (String, 必填)：模糊搜尋關鍵字。
  - `page` (Int?, 選填)：分頁索引，未提供則使用 TMDB 預設。
  - `include_adult` (Bool, 預設 `false`)：是否返回成人內容。
  - `region` (String?, 選填)：ISO 3166-1 區域碼，用於語系/市場偏好。
  - `year` (Int?, 選填)：過濾發行年份。
  - `primary_release_year` (Int?, 選填)：過濾主要上映年份。
- 回應：`MovieResponse`（分頁電影清單）。

## 電影
### MovieDetails
- 路徑：`GET /movie/{movie_id}`
- 參數：`movie_id` (Int, 路徑必填)；查詢參數無，會自動附帶 `language`。
- 回應：`MovieDetailResponse`（電影詳細資料）。

### MovieCredits
- 路徑：`GET /movie/{movie_id}/credits`
- 參數：`movie_id` (Int, 路徑必填)；無額外查詢參數。
- 回應：`CreditsResponse`（演員與工作人員名單）。

### MovieVideos
- 路徑：`GET /movie/{movie_id}/videos`
- 參數：`movie_id` (Int, 路徑必填)；無額外查詢參數。
- 回應：`MovieVideosResponse`（預告、剪輯、Teaser 等影片列表）。

### TrendingMovies
- 路徑：`GET /trending/movie/{time_window}`
- 參數：
  - `time_window` (`day`|`week`, 路徑必填)：統計時間窗。
  - `page` (Int?, 選填)：分頁索引。
- 回應：`MovieResponse`（趨勢電影列表）。

### PopularMovies
- 路徑：`GET /movie/popular`
- 參數：
  - `page` (Int?, 選填)：分頁索引。
  - `region` (String?, 選填)：ISO 3166-1 區域碼。
- 回應：`MovieResponse`（TMDB Popular 清單）。

### TopRatedMovies
- 路徑：`GET /movie/top_rated`
- 參數：
  - `page` (Int?, 選填)：分頁索引。
  - `region` (String?, 選填)：ISO 3166-1 區域碼。
- 回應：`MovieResponse`（高評分電影清單）。

### UpcomingMovies
- 路徑：`GET /movie/upcoming`
- 參數：
  - `page` (Int?, 選填)：分頁索引。
  - `region` (String?, 選填)：ISO 3166-1 區域碼。
- 回應：`MovieResponse`（即將上映電影）。

### NowPlayingMovies
- 路徑：`GET /movie/now_playing`
- 參數：
  - `page` (Int?, 選填)：分頁索引。
  - `region` (String?, 選填)：ISO 3166-1 區域碼。
- 回應：`MovieResponse`（現正上映電影）。

### SimilarMovies
- 路徑：`GET /movie/{movie_id}/similar`
- 參數：
  - `movie_id` (Int, 路徑必填)：基準電影。
  - `page` (Int?, 選填)：分頁索引。
- 回應：`MovieResponse`（推薦的相似電影）。

## 類別
### MovieGenres
- 路徑：`GET /genre/movie/list`
- 參數：無額外查詢參數；自動附帶 `language`。
- 回應：`GenreResponse`（電影類別清單）。

## 人物
### PersonDetails
- 路徑：`GET /person/{person_id}`
- 參數：`person_id` (Int, 路徑必填)。
- 回應：`PersonDetailResponse`（人物基本資料與簡介）。

### PersonMovieCredits
- 路徑：`GET /person/{person_id}/movie_credits`
- 參數：`person_id` (Int, 路徑必填)。
- 回應：`PersonMovieCreditsResponse`（參與演出與製作的電影清單）。

## 授權
### RequestToken
- 路徑：`GET /authentication/token/new`
- 認證：強制使用 v3 `apiKey` query 參數。
- 參數：無額外查詢參數；自動附帶 `language`。
- 回應：`RequestTokenResponse`（授權頁使用的 request_token）。

### CreateSession
- 路徑：`POST /authentication/session/new`
- 認證：強制使用 v3 `apiKey` query 參數。
- Body：`{"request_token": "<已授權 token>"}`，`Content-Type: application/json`。
- 回應：`CreateSessionResponse`（成功時包含 `session_id`）。

### ValidateTokenWithLogin
- 路徑：`POST /authentication/token/validate_with_login`
- 認證：強制使用 v3 `apiKey` query 參數。
- Body：`{"username":"<tmdb username>","password":"<tmdb password>","request_token":"<token>"}`，`Content-Type: application/json`。
- 回應：`RequestTokenResponse`（成功時回傳已驗證的 `request_token` 與到期時間）。
