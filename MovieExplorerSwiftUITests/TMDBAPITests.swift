//
//  TMDBAPITests.swift
//  MovieExplorerSwiftUITests
//
//  Created by Brant on 2025/11/28.
//

import XCTest
@testable import MovieExplorerSwiftUI

final class TMDBAPITests: XCTestCase {

    private var service: TMDBServiceProtocol!

    override func setUpWithError() throws {
        service = FakeTMDBService()
    }

    override func tearDownWithError() throws {
        service = nil
    }
    
    func testTrendingMoviesAPI_ReturnsResults() async throws {
        let response: MovieResponse = try await service.request(TrendingMovies())

        XCTAssertFalse(response.results.isEmpty, "Trending API should return movies")
        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.results.first?.title, "Zootopia 2")
    }

    func testMovieDetailsAPI_ReturnsDetail() async throws {
        let response: MovieDetailResponse = try await service.request(MovieDetails(movieID: 1084242))

        XCTAssertEqual(response.id, 1084242, "Should load requested movie ID")
        XCTAssertFalse(response.title.isEmpty, "Movie title should not be empty")
        XCTAssertNotNil(response.releaseDate, "Movie details should include release date")
        XCTAssertEqual(response.posterURL?.absoluteString, TMDBConfig.posterBaseURL + "/oJ7g2CifqpStmoYQyaLQgEU32qO.jpg")
    }

    func testNowPlayingMoviesAPI_ReturnsResults() async throws {
        let response: MovieResponse = try await service.request(NowPlayingMovies())

        XCTAssertFalse(response.results.isEmpty, "Now Playing API should return movies")
        XCTAssertNotNil(response.results.first?.releaseDate, "Now Playing movies should include release dates")
    }

    func testUpcomingMoviesAPI_ReturnsResults() async throws {
        let response: MovieResponse = try await service.request(UpcomingMovies())

        XCTAssertFalse(response.results.isEmpty, "Upcoming API should return movies")
        XCTAssertNotNil(response.results.first?.releaseDate, "Upcoming movies should include release dates")
    }

    func testConfigurationDetailsAPI_ReturnsImageConfig() async throws {
        let response: ConfigurationDetailsResponse = try await service.request(ConfigurationDetails())

        XCTAssertFalse(response.images.posterSizes.isEmpty, "Configuration API should return image sizes")
        XCTAssertEqual(response.images.secureBaseURL, "https://image.tmdb.org/t/p/")
    }

    func testPersonDetailsAPI_ReturnsPerson() async throws {
        let response: PersonDetailResponse = try await service.request(PersonDetails(personID: 287))

        XCTAssertEqual(response.id, 287)
        XCTAssertEqual(response.name, "Brad Pitt")
        XCTAssertEqual(response.knownForDepartment, "Acting")
        XCTAssertEqual(response.alsoKnownAs.count, 2)
        XCTAssertEqual(response.profileURL?.absoluteString, "https://image.tmdb.org/t/p/w185/cckcYc2v0yh1tc9QjRelptcOBko.jpg")
    }

    func testPersonMovieCreditsAPI_ReturnsCastAndCrew() async throws {
        let response: PersonMovieCreditsResponse = try await service.request(PersonMovieCredits(personID: 287))

        XCTAssertEqual(response.id, 287)
        XCTAssertFalse(response.cast.isEmpty, "Cast credits should not be empty")
        XCTAssertFalse(response.crew.isEmpty, "Crew credits should not be empty")

        let cast = try XCTUnwrap(response.cast.first)
        XCTAssertEqual(cast.title, "Ocean's Twelve")
        XCTAssertEqual(cast.character, "Rusty Ryan")
        XCTAssertEqual(cast.mediaType, .movie)
        XCTAssertEqual(cast.posterURL?.absoluteString, TMDBConfig.posterBaseURL + "/4eCFDi1nB3PEfrq5ulJXryI2PSE.jpg")

        let crew = try XCTUnwrap(response.crew.first)
        XCTAssertEqual(crew.title, "Fight Club")
        XCTAssertEqual(crew.job, "Producer")
        XCTAssertEqual(crew.department, "Production")
    }

}
