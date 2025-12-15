//
//  TMDBAuthTests.swift
//  MovieExplorerSwiftUITests
//
//  Created by Brant on 2025/12/15.
//

import XCTest
@testable import MovieExplorerSwiftUI

final class TMDBAuthTests: XCTestCase {

    func testValidateTokenWithLogin_BuildsExpectedRequest() throws {
        let endpoint = ValidateTokenWithLogin(
            username: "test_user",
            password: "test_pass",
            requestToken: "token_123"
        )

        XCTAssertEqual(endpoint.method, .post)
        XCTAssertEqual(endpoint.path, "/authentication/token/validate_with_login")
        XCTAssertEqual(endpoint.headers["Content-Type"], "application/json")

        let auth = try XCTUnwrap(endpoint.authMethodOverride)
        switch auth {
        case .apiKey(let key):
            XCTAssertFalse(key.isEmpty)
        case .bearerToken:
            XCTFail("ValidateTokenWithLogin 應強制使用 v3 api_key")
        }

        let bodyData = try XCTUnwrap(endpoint.body)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: bodyData) as? [String: Any])
        XCTAssertEqual(json["username"] as? String, "test_user")
        XCTAssertEqual(json["password"] as? String, "test_pass")
        XCTAssertEqual(json["request_token"] as? String, "token_123")
    }

    func testAuthServiceCreateSessionFromLogin_ReturnsSessionID() async throws {
        let spy = SpyTMDBService()
        let authService = AuthService(service: spy)

        let result = try await authService.createSessionFromLogin(username: "u", password: "p")

        XCTAssertEqual(result.sessionID, "session_abc")
        XCTAssertTrue(result.approved)
        XCTAssertEqual(result.requestToken, "token_validated")

        let endpoints = await spy.requestedEndpoints
        XCTAssertEqual(endpoints.count, 3)
        XCTAssertTrue(endpoints[0] is RequestToken)
        XCTAssertTrue(endpoints[1] is ValidateTokenWithLogin)
        XCTAssertTrue(endpoints[2] is CreateSession)
    }

    func testGuestSessionResponse_DecodesSuccessfully() throws {
        let data = try XCTUnwrap(GuestSessionResponse.mockJson.data(using: .utf8))
        let decoded = try JSONDecoder().decode(GuestSessionResponse.self, from: data)

        XCTAssertTrue(decoded.success)
        XCTAssertEqual(decoded.guestSessionID, "mock_guest_session_id")
        XCTAssertEqual(decoded.expiresAt, "2025-12-31 23:59:59 UTC")
    }

    @MainActor
    func testAuthStoreLoginWithCredentials_UpdatesIdentity() async {
        let spy = SpyTMDBService()
        let authService = AuthService(service: spy)
        let store = AuthStore(authService: authService)

        await store.loginWithTMDBCredentials(username: "u", password: "p")

        if case .loggedIn(let sessionID, _) = store.identity {
            XCTAssertEqual(sessionID, "session_abc")
        } else {
            XCTFail("期望登入後 identity 為 loggedIn")
        }
        XCTAssertNil(store.authErrorMessage)
    }

    func testAuthServiceCreateGuestSession_ReturnsGuestSessionIDAndExpiresAt() async throws {
        let spy = SpyTMDBService()
        let authService = AuthService(service: spy)

        let result = try await authService.createGuestSession()

        XCTAssertEqual(result.sessionID, "guest_abc")
        XCTAssertNotNil(result.expiresAt)

        let endpoints = await spy.requestedEndpoints
        XCTAssertEqual(endpoints.count, 1)
        XCTAssertTrue(endpoints[0] is CreateGuestSession)
    }

    @MainActor
    func testAuthStoreLoginAsGuest_UpdatesIdentity() async {
        let spy = SpyTMDBService()
        let authService = AuthService(service: spy)
        let store = AuthStore(authService: authService)

        await store.loginAsGuest()

        if case .guest(let guestSessionID, let expiresAt) = store.identity {
            XCTAssertEqual(guestSessionID, "guest_abc")
            XCTAssertNotNil(expiresAt)
        } else {
            XCTFail("期望訪客登入後 identity 為 guest")
        }
        XCTAssertNil(store.authErrorMessage)
    }

    @MainActor
    func testAuthStoreHandleCallback_ApprovedTrue_UpdatesIdentity() async throws {
        let spy = SpyTMDBService()
        let authService = AuthService(service: spy)
        let store = AuthStore(authService: authService)

        let url = try XCTUnwrap(URL(string: "movieexplorer://auth/callback?request_token=token_validated&approved=true"))
        await store.handleAuthCallback(url: url)

        if case .loggedIn(let sessionID, _) = store.identity {
            XCTAssertEqual(sessionID, "session_abc")
        } else {
            XCTFail("期望授權回呼後 identity 為 loggedIn")
        }
        XCTAssertNil(store.authErrorMessage)
    }
}

/// 以固定回傳值與呼叫記錄驗證 AuthService 流程的測試用服務
actor SpyTMDBService: TMDBServiceProtocol {

    /// 依序記錄被呼叫的 endpoint（用於斷言呼叫順序）
    private(set) var requestedEndpoints: [Any] = []

    func request<E: TMDBEndpointProtocol>(_ endpoint: E) async throws -> E.Response {
        requestedEndpoints.append(endpoint)

        if endpoint is RequestToken {
            return RequestTokenResponse(
                success: true,
                expiresAt: "2025-12-31 23:59:59 UTC",
                requestToken: "token_unvalidated"
            ) as! E.Response
        }

        if let validate = endpoint as? ValidateTokenWithLogin {
            XCTAssertEqual(validate.username, "u")
            XCTAssertEqual(validate.password, "p")
            XCTAssertEqual(validate.requestToken, "token_unvalidated")
            return RequestTokenResponse(
                success: true,
                expiresAt: "2025-12-31 23:59:59 UTC",
                requestToken: "token_validated"
            ) as! E.Response
        }

        if let create = endpoint as? CreateSession {
            XCTAssertEqual(create.requestToken, "token_validated")
            return CreateSessionResponse(success: true, sessionID: "session_abc") as! E.Response
        }

        if endpoint is CreateGuestSession {
            return GuestSessionResponse(
                success: true,
                guestSessionID: "guest_abc",
                expiresAt: "2025-12-31 23:59:59 UTC"
            ) as! E.Response
        }

        fatalError("Unexpected endpoint: \(type(of: endpoint))")
    }
}
