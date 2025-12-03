# Repository Guidelines

## Project Structure & Module Organization
MovieExplorerSwiftUI follows a feature-first layout. App entry points, coordinators, and shared UI utilities live under `MovieExplorerSwiftUI/App`, while flows such as Home, Search, and Watchlist are grouped inside `MovieExplorerSwiftUI/Features/<FeatureName>`. Networking clients and request definitions live in `MovieExplorerSwiftUI/Core/API`. DTOs sit in `MovieExplorerSwiftUI/Core/Models`; they conform to `Decodable` and add `Mockable` conformance whenever previews need fixtures. All visual assets belong to `MovieExplorerSwiftUI/Assets.xcassets`, and UI regression helpers plus snapshot fixtures live in `MovieExplorerSwiftUITests`.

## Build, Test, and Development Commands
Compile the project with `xcodebuild -scheme MovieExplorerSwiftUI -destination 'generic/platform=iOS' build` to catch compiler regressions quickly. Execute `xcodebuild -scheme MovieExplorerSwiftUI -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.4' test` before pushing so the XCTest suite (including async networking stubs) runs in a predictable simulator. Launch an editable workspace with `xed .` when iterating locally. Previews and manual smoke tests should rely on `FakeTMDBService` or dependency injection of stored fixtures to avoid real API calls.

## Coding Style & Naming Conventions
Use Swift 5 defaults with four-space indentation, `UpperCamelCase` types, `lowerCamelCase` properties/functions, and reserve `SCREAMING_SNAKE_CASE` for global constants like `TMDBConfig.apiKey`. Keep files near their features to avoid mega “Common” folders, e.g., reusable carousel components belong in `Features/Home/Components/`. Append `Protocol` only when disambiguation is needed (`TMDBServiceProtocol`). Async functions should expose intent (`loadTrending()`, `refreshWatchlist()`), and prefer small extensions over new utility files.

## Testing Guidelines
Tests are written with XCTest; name them `test<Scenario>_<ExpectedBehavior>()` (e.g., `testTrendingMoviesAPI_ReturnsResults`). Always inject `FakeTMDBService` or local JSON fixtures in tests and previews so runs are deterministic. Run the simulator-based `xcodebuild … test` command before submitting for review, and keep async expectations tight with explicit timeouts to avoid flakes. When adding DTOs, include simple decoding tests to capture schema drift.

## Commit & Pull Request Guidelines
Write focused commits with imperative subjects (`Add HomeView hero banner`) and reference issues where applicable (`Fix watchlist sync (#42)`). Pull requests should summarize the change, list verification commands, and attach screenshots or simulator recordings for UI work. Call out API additions, `TMDBConfig` tweaks, or new mock fixtures in the description so reviewers know which configurations to update.

## Security & Configuration Tips
Never check in real TMDB API keys; keep them in `APIKey.json` or secure environment variables. When adding endpoints, update `TMDBConfig`, provide mock payloads, and document required parameters. Review logs and debug prints before committing to ensure no credentials or user data are exposed.
