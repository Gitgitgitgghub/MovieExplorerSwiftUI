//
//  TMDBAPITests.swift
//  MovieExplorerSwiftUITests
//
//  Created by Brant on 2025/11/28.
//

import XCTest
@testable import MovieExplorerSwiftUI

final class TMDBAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTrendingMoviesAPI_ReturnsResults() async throws {
        let service = TMDBService()

        let response: MovieResponse = try await service.request(TrendingMovies())

        XCTAssertFalse(response.results.isEmpty, "Trending API should return movies")

        print("Trending first movie:", response.results.first?.title ?? "N/A")
    }

    func testMovieDetailsAPI_ReturnsDetail() async throws {
        let service = TMDBService()

        let response: MovieDetailResponse = try await service.request(MovieDetails(movieID: 1084242))

        XCTAssertEqual(response.id, 1084242, "Should load requested movie ID")
        XCTAssertFalse(response.title.isEmpty, "Movie title should not be empty")
        XCTAssertNotNil(response.releaseDate, "Movie details should include release date")

        print("Movie details title:", response.title)
    }

    func testNowPlayingMoviesAPI_ReturnsResults() async throws {
        let service = TMDBService()

        let response: MovieResponse = try await service.request(NowPlayingMovies())

        XCTAssertFalse(response.results.isEmpty, "Now Playing API should return movies")
        XCTAssertNotNil(response.results.first?.releaseDate, "Now Playing movies should include release dates")

        print("Now Playing first movie:", response.results.first?.title ?? "N/A")
    }

    func testUpcomingMoviesAPI_ReturnsResults() async throws {
        let service = TMDBService()

        let response: MovieResponse = try await service.request(UpcomingMovies())

        XCTAssertFalse(response.results.isEmpty, "Upcoming API should return movies")
        XCTAssertNotNil(response.results.first?.releaseDate, "Upcoming movies should include release dates")

        print("Upcoming first movie:", response.results.first?.title ?? "N/A")
    }

    func testConfigurationDetailsAPI_ReturnsImageConfig() async throws {
        let service = TMDBService()

        let response: ConfigurationDetailsResponse = try await service.request(ConfigurationDetails())

        XCTAssertFalse(response.images.posterSizes.isEmpty, "Configuration API should return image sizes")

        print("Poster sizes:", response.images.posterSizes)
    }

}
