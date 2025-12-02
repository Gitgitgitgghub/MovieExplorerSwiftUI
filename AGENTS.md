# Repository Guidelines

## Project Structure & Module Organization
- `MovieExplorerSwiftUI/` contains app code organized by feature (`Features/Home`, `Features/Search`, etc.), shared UI under `App/`, and networking in `Core/API`.
- `Core/Models` stores DTOs such as `MovieResponse.swift`, each conforming to `Decodable` and, when useful, `Mockable` for previews.
- Assets live in `MovieExplorerSwiftUI/Assets.xcassets`. UI tests reside in `MovieExplorerSwiftUITests/`.
- Coordinated navigation flows through `App/AppCoordinator.swift`, while previews often inject `FakeTMDBService`.

## Build, Test, and Development Commands
- `xcodebuild -scheme MovieExplorerSwiftUI -destination 'generic/platform=iOS' build` compiles the app for CI or linting workflows.
- `xcodebuild -scheme MovieExplorerSwiftUI -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.4' test` runs the XCTest suite (`MovieExplorerSwiftUITests`).
- `xed .` (optional) opens the project in Xcode for interactive development.

## Coding Style & Naming Conventions
- Use Swift 5 standards: four-space indentation, `UpperCamelCase` for types, `lowerCamelCase` for properties/functions, `SCREAMING_SNAKE_CASE` only for global constants like `TMDBConfig.apiKey`.
- Group files by feature module; prefer dedicated folders (`Features/Home/Component/`) for reusable views.
- Protocols end with `Protocol` only when needed to disambiguate (`TMDBServiceProtocol`), and async methods should surface intent (`loadTrending()` vs. `fetch()`).

## Testing Guidelines
- Tests use XCTest; name methods `test<Scenario>_<ExpectedBehavior>()`, e.g. `testTrendingMoviesAPI_ReturnsResults`.
- Favor mock services by injecting `FakeTMDBService` instead of hitting the real TMDB API unless performing integration checks.
- Run `xcodebuild … test` before submitting changes; ensure async tests await expectations and avoid flakiness by isolating network calls.

## Commit & Pull Request Guidelines
- Keep commits focused with imperative subjects (`Add HomeView hero banner`). Reference issues when applicable (`Fix watchlist sync (#42)`).
- Pull requests should summarize the feature/fix, list testing steps (commands run), and include screenshots or simulator recordings for UI updates.
- Highlight any API key or configuration changes and note if new endpoints require updates to `TMDBConfig` or `Mockable` fixtures.
