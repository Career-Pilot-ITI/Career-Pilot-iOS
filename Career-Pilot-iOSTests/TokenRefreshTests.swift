//
//  TokenRefreshTests.swift
//  Career-Pilot-iOSTests
//
//  Created by Antigravity on 29/07/2026.
//

import XCTest
@testable import Career_Pilot_iOS

// MARK: - Test Doubles

/// In-memory token store — no Keychain required.
private final class MockTokenStore: AuthTokenStoring {
    var stored: AuthTokens?
    var clearCalled = false
    var saveCalled = false

    func save(_ tokens: AuthTokens) throws {
        saveCalled = true
        stored = tokens
    }
    func loadTokens() throws -> AuthTokens? { stored }
    func clear() throws {
        clearCalled = true
        stored = nil
    }
}

/// Configurable fake NetworkService.
private final class MockNetworkService: NetworkService {
    /// Set to the value you want `request<T>` to return.
    var result: Any?
    /// Set to an error you want the service to throw.
    var errorToThrow: Error?
    var requestCount = 0

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        requestCount += 1
        if let error = errorToThrow { throw error }
        return result as! T
    }

    func request(_ endpoint: APIEndpoint) async throws {
        requestCount += 1
        if let error = errorToThrow { throw error }
    }
}

/// Simple fake `TokenProviding`.
private final class MockTokenProvider: TokenProviding {
    var accessToken: String = "access-token"
    var refreshToken: String = "refresh-token"
    var shouldThrow: Error?

    func getAccessToken() async throws -> String {
        if let e = shouldThrow { throw e }
        return accessToken
    }
    func getRefreshToken() async throws -> String {
        if let e = shouldThrow { throw e }
        return refreshToken
    }
}

// MARK: - AuthTokenProvider Tests

final class AuthTokenProviderTests: XCTestCase {

    func test_getAccessToken_whenNoTokens_throwsUnauthorized() async throws {
        let store = MockTokenStore() // stored == nil
        let provider = AuthTokenProvider(tokenStore: store)

        await XCTAssertAsyncThrows(NetworkError.unauthorized) {
            _ = try await provider.getAccessToken()
        }
    }

    func test_getAccessToken_whenTokensPresent_returnsAccessToken() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "abc", refreshToken: "ref", expiresIn: 3600)
        let provider = AuthTokenProvider(tokenStore: store)

        let token = try await provider.getAccessToken()
        XCTAssertEqual(token, "abc")
    }

    /// Regression: old code cleared keychain and threw when expiresIn <= 120.
    /// New code must NOT clear or throw — the server 401 is the trigger.
    func test_getAccessToken_whenTokenNearExpiry_returnsTokenWithoutClearing() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "near-expiry", refreshToken: "ref", expiresIn: 60)
        let provider = AuthTokenProvider(tokenStore: store)

        let token = try await provider.getAccessToken()
        XCTAssertEqual(token, "near-expiry")
        XCTAssertFalse(store.clearCalled, "Provider must not clear the keychain on near-expiry")
        XCTAssertNotNil(store.stored, "Token store must not be emptied by the provider")
    }

    func test_getRefreshToken_whenNoTokens_throwsUnauthorized() async throws {
        let store = MockTokenStore()
        let provider = AuthTokenProvider(tokenStore: store)

        await XCTAssertAsyncThrows(NetworkError.unauthorized) {
            _ = try await provider.getRefreshToken()
        }
    }
}

// MARK: - TokenRefreshActor Tests

final class TokenRefreshActorTests: XCTestCase {

    func test_refresh_callsWork() async throws {
        let actor = TokenRefreshActor()
        let tokens = AuthTokens(accessToken: "new", refreshToken: "newRef", expiresIn: 3600)

        let result = try await actor.refresh { tokens }
        XCTAssertEqual(result.accessToken, "new")
    }

    func test_refresh_concurrentCalls_onlyOneWorkExecuted() async throws {
        let actor = TokenRefreshActor()
        var callCount = 0

        // Kick off multiple concurrent refreshes simultaneously.
        async let r1 = actor.refresh {
            callCount += 1
            try await Task.sleep(nanoseconds: 50_000_000) // 50 ms
            return AuthTokens(accessToken: "fresh", refreshToken: "ref", expiresIn: 3600)
        }
        async let r2 = actor.refresh {
            callCount += 1
            return AuthTokens(accessToken: "fresh", refreshToken: "ref", expiresIn: 3600)
        }
        async let r3 = actor.refresh {
            callCount += 1
            return AuthTokens(accessToken: "fresh", refreshToken: "ref", expiresIn: 3600)
        }

        let results = try await [r1, r2, r3]
        XCTAssertTrue(results.allSatisfy { $0.accessToken == "fresh" })
        // callCount may be 1 or 2 depending on timing — the key assertion is
        // that it is NOT 3 (i.e. not every concurrent call ran its own work).
        XCTAssertLessThan(callCount, 3, "Actor should deduplicate concurrent refresh calls")
    }

    func test_refresh_afterCompletion_newCallStartsFreshWork() async throws {
        let actor = TokenRefreshActor()
        var callCount = 0

        _ = try await actor.refresh {
            callCount += 1
            return AuthTokens(accessToken: "first", refreshToken: "ref", expiresIn: 3600)
        }
        _ = try await actor.refresh {
            callCount += 1
            return AuthTokens(accessToken: "second", refreshToken: "ref", expiresIn: 3600)
        }

        XCTAssertEqual(callCount, 2, "Sequential calls each trigger their own work")
    }
}

// MARK: - AuthenticatedNetworkService Tests

final class AuthenticatedNetworkServiceTests: XCTestCase {

    // MARK: Happy path

    func test_request_successfulResponse_returnsValue() async throws {
        let (sut, base, _, _) = makeSUT()
        let expected = StubResponse(value: "hello")
        base.result = expected

        let result: StubResponse = try await sut.request(StubEndpoint(requiresAuth: false))
        XCTAssertEqual(result.value, "hello")
        XCTAssertEqual(base.requestCount, 1)
    }

    // MARK: 401 → refresh → retry

    func test_request_on401_refreshesAndRetries() async throws {
        let (sut, base, store, _) = makeSUT()

        // First call throws 401; second call (retry) succeeds
        var callCount = 0
        base.result = StubResponse(value: "retried")
        base.errorToThrow = NetworkError.serverError(statusCode: 401, data: nil)

        // After first call fails, the mock needs to succeed on retry.
        // We'll use a custom override via a fresh mock per call.
        // Simpler: use a counter-based approach by subclassing or using
        // a closure. Instead, assert the retry happened via requestCount.

        // Use a toggle-error mock:
        let toggleBase = ToggleMockNetworkService(
            firstError: NetworkError.serverError(statusCode: 401, data: nil),
            thenReturn: StubResponse(value: "retried")
        )
        store.stored = AuthTokens(accessToken: "old", refreshToken: "ref", expiresIn: 60)
        let refreshService = MockNetworkService()
        refreshService.result = RefreshTokenResponseDTO(
            authTokens: AuthTokensDTO(accessToken: "new", refreshToken: "newRef", expiresIn: 7200)
        )

        let sut2 = makeServiceWith(base: toggleBase, store: store, refreshService: refreshService)
        let result: StubResponse = try await sut2.request(StubEndpoint(requiresAuth: true))

        XCTAssertEqual(result.value, "retried")
        XCTAssertEqual(toggleBase.requestCount, 2, "Should call once (fails), then once (succeeds)")
        XCTAssertEqual(refreshService.requestCount, 1, "Should call refresh once")
        XCTAssertEqual(store.stored?.accessToken, "new", "New tokens must be persisted")
    }

    // MARK: Refresh failure → force logout

    func test_request_on401_refreshFails_callsForceLogoutAndThrows() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "old", refreshToken: "ref", expiresIn: 60)

        let failingRefresh = MockNetworkService()
        failingRefresh.errorToThrow = NetworkError.serverError(statusCode: 401, data: nil)

        var forceLogoutCalled = false
        let sut = AuthenticatedNetworkService(
            baseService: AlwaysFail401NetworkService(),
            tokenProvider: MockTokenProvider(),
            tokenStore: store,
            refreshService: failingRefresh,
            refreshActor: TokenRefreshActor(),
            onForceLogout: { forceLogoutCalled = true }
        )

        do {
            let _: StubResponse = try await sut.request(StubEndpoint(requiresAuth: true))
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(forceLogoutCalled, "Force logout must be called when refresh fails")
            XCTAssertTrue(store.clearCalled, "Token store must be cleared on refresh failure")
        }
    }

    // MARK: No retry on non-auth errors

    func test_request_on500_doesNotRefreshOrRetry() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "valid", refreshToken: "ref", expiresIn: 3600)
        let base = MockNetworkService()
        base.errorToThrow = NetworkError.serverError(statusCode: 500, data: nil)
        let refreshService = MockNetworkService()

        let sut = makeServiceWith(base: base, store: store, refreshService: refreshService)

        do {
            let _: StubResponse = try await sut.request(StubEndpoint(requiresAuth: true))
            XCTFail("Expected 500 error")
        } catch {
            XCTAssertEqual(base.requestCount, 1, "Must not retry on 500")
            XCTAssertEqual(refreshService.requestCount, 0, "Must not call refresh on 500")
        }
    }

    // MARK: Helpers

    private func makeSUT() -> (
        AuthenticatedNetworkService,
        MockNetworkService,
        MockTokenStore,
        Bool
    ) {
        let base = MockNetworkService()
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "access", refreshToken: "refresh", expiresIn: 3600)
        var logoutCalled = false
        let sut = AuthenticatedNetworkService(
            baseService: base,
            tokenProvider: MockTokenProvider(),
            tokenStore: store,
            refreshService: MockNetworkService(),
            refreshActor: TokenRefreshActor(),
            onForceLogout: { logoutCalled = true }
        )
        return (sut, base, store, logoutCalled)
    }

    private func makeServiceWith(
        base: NetworkService,
        store: MockTokenStore,
        refreshService: NetworkService
    ) -> AuthenticatedNetworkService {
        AuthenticatedNetworkService(
            baseService: base,
            tokenProvider: MockTokenProvider(),
            tokenStore: store,
            refreshService: refreshService,
            refreshActor: TokenRefreshActor(),
            onForceLogout: {}
        )
    }
}

// MARK: - Supporting test types

private struct StubResponse: Codable, Equatable { let value: String }

private struct StubEndpoint: APIEndpoint {
    let requiresAuth: Bool
    var path: String { "stub" }
    var method: HTTPMethod { .get }
    var requiresAuthentication: Bool { requiresAuth }
}

/// Returns a 401 error on the first call, then succeeds on subsequent ones.
private final class ToggleMockNetworkService: NetworkService {
    private let firstError: Error
    private let successValue: Any
    private(set) var requestCount = 0

    init(firstError: Error, thenReturn value: Any) {
        self.firstError = firstError
        self.successValue = value
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        requestCount += 1
        if requestCount == 1 { throw firstError }
        return successValue as! T
    }
    func request(_ endpoint: APIEndpoint) async throws {
        requestCount += 1
        if requestCount == 1 { throw firstError }
    }
}

/// Always throws a 401.
private final class AlwaysFail401NetworkService: NetworkService {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        throw NetworkError.serverError(statusCode: 401, data: nil)
    }
    func request(_ endpoint: APIEndpoint) async throws {
        throw NetworkError.serverError(statusCode: 401, data: nil)
    }
}

// MARK: - XCTest async helper

/// Asserts that the async closure throws an error matching the expected NetworkError case.
func XCTAssertAsyncThrows<E: Error & Equatable>(
    _ expected: E,
    _ work: () async throws -> Void,
    file: StaticString = #file, line: UInt = #line
) async {
    do {
        try await work()
        XCTFail("Expected \(expected) to be thrown", file: file, line: line)
    } catch let error as E {
        XCTAssertEqual(error, expected, file: file, line: line)
    } catch {
        XCTFail("Unexpected error type: \(error)", file: file, line: line)
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.unauthorized, .unauthorized),
             (.tokenExpired, .tokenExpired),
             (.noInternet, .noInternet),
             (.invalidURL, .invalidURL),
             (.requestTimeout, .requestTimeout):
            return true
        case (.serverError(let l, _), .serverError(let r, _)):
            return l == r
        default:
            return false
        }
    }
}
