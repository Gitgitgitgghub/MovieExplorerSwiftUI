import XCTest
@testable import MovieExplorerSwiftUI

final class TMDBConfigTests: XCTestCase {

    func testLoadAPIKeyFromCustomJSONReturnsValue() throws {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
        let payload = """
        {"apiKey":"test_value"}
        """
        try payload.write(to: tempURL, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: tempURL) }

        let key = try TMDBConfig.loadAPIKey(from: tempURL)

        XCTAssertEqual(key, "test_value")
    }
}
