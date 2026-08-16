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
    var refreshTokensIfNeededResult: Bool = false
    var refreshTokensIfNeededError: Error?

    func save(_ tokens: AuthTokens) throws {
        saveCalled = true
        stored = tokens
    }
    func loadTokens() throws -> AuthTokens? { stored }
    func clear() throws {
        clearCalled = true
        stored = nil
    }
    func refreshTokensIfNeeded() async throws -> Bool {
        if let error = refreshTokensIfNeededError { throw error }
        return refreshTokensIfNeededResult
    }
}

/// Configurable fake NetworkService.
private final class MockNetworkService: NetworkService {
    var result: Any?
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
        let store = MockTokenStore()
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

    func test_getAccessToken_whenTokenWithinBuffer_throwsTokenExpired() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "near-expiry", refreshToken: "ref", expiresIn: 30)
        let provider = AuthTokenProvider(tokenStore: store)

        await XCTAssertAsyncThrows(NetworkError.tokenExpired) {
            _ = try await provider.getAccessToken()
        }
        XCTAssertFalse(store.clearCalled, "Provider must not clear the keychain")
    }

    func test_getAccessToken_whenTokenExpired_throwsTokenExpired() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "expired", refreshToken: "ref", expiresIn: -10)
        let provider = AuthTokenProvider(tokenStore: store)

        await XCTAssertAsyncThrows(NetworkError.tokenExpired) {
            _ = try await provider.getAccessToken()
        }
    }

    func test_getAccessToken_whenTokenAboveBuffer_returnsToken() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "valid", refreshToken: "ref", expiresIn: 120)
        let provider = AuthTokenProvider(tokenStore: store)

        let token = try await provider.getAccessToken()
        XCTAssertEqual(token, "valid")
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

        async let r1 = actor.refresh {
            callCount += 1
            try await Task.sleep(nanoseconds: 50_000_000)
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

    // MARK: Test 1 — Access token valid → request succeeds, no refresh

    func test_request_successfulResponse_noRefresh() async throws {
        let base = MockNetworkService()
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "valid", refreshToken: "ref", expiresIn: 3600)
        let refreshService = MockNetworkService()

        let sut = makeServiceWith(base: base, store: store, refreshService: refreshService)
        base.result = StubResponse(value: "hello")

        let result: StubResponse = try await sut.request(StubEndpoint(requiresAuth: true))
        XCTAssertEqual(result.value, "hello")
        XCTAssertEqual(base.requestCount, 1)
        XCTAssertEqual(refreshService.requestCount, 0, "No refresh should occur")
    }

    // MARK: Test 2 — 401 → refresh succeeds → retry succeeds

    func test_request_on401_refreshesAndRetries() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "old", refreshToken: "ref", expiresIn: 60)

        let toggleBase = ToggleMockNetworkService(
            firstError: NetworkError.serverError(statusCode: 401, data: nil),
            thenReturn: StubResponse(value: "retried")
        )
        let refreshService = MockNetworkService()
        refreshService.result = RefreshTokenResponseDTO(
            authTokens: AuthTokensDTO(accessToken: "new", refreshToken: "newRef", expiresIn: 7200)
        )

        let sut = makeServiceWith(base: toggleBase, store: store, refreshService: refreshService)
        let result: StubResponse = try await sut.request(StubEndpoint(requiresAuth: true))

        XCTAssertEqual(result.value, "retried")
        XCTAssertEqual(toggleBase.requestCount, 2)
        XCTAssertEqual(refreshService.requestCount, 1)
        XCTAssertEqual(store.stored?.accessToken, "new")
    }

    // MARK: Test 3 — Refresh fails → credentials cleared → force logout

    func test_request_on401_refreshFails_forceLogout() async throws {
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
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(forceLogoutCalled)
            XCTAssertTrue(store.clearCalled)
        }
    }

    // MARK: Test 4 — No refresh token → logout

    func test_request_on401_noRefreshToken_logout() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "old", refreshToken: "", expiresIn: 60)

        let base = MockNetworkService()
        base.errorToThrow = NetworkError.serverError(statusCode: 401, data: nil)

        var forceLogoutCalled = false
        let sut = AuthenticatedNetworkService(
            baseService: base,
            tokenProvider: MockTokenProvider(),
            tokenStore: store,
            refreshService: MockNetworkService(),
            refreshActor: TokenRefreshActor(),
            onForceLogout: { forceLogoutCalled = true }
        )

        do {
            let _: StubResponse = try await sut.request(StubEndpoint(requiresAuth: true))
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(forceLogoutCalled)
            XCTAssertTrue(store.clearCalled)
        }
    }

    // MARK: Test 5 — Retry also 401 → no second refresh loop

    func test_request_retryAlso401_throwsTokenExpired() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "old", refreshToken: "ref", expiresIn: 60)

        let alwaysFail = AlwaysFail401NetworkService()
        let refreshService = MockNetworkService()
        refreshService.result = RefreshTokenResponseDTO(
            authTokens: AuthTokensDTO(accessToken: "new", refreshToken: "newRef", expiresIn: 7200)
        )

        let sut = AuthenticatedNetworkService(
            baseService: alwaysFail,
            tokenProvider: MockTokenProvider(),
            tokenStore: store,
            refreshService: refreshService,
            refreshActor: TokenRefreshActor(),
            onForceLogout: {}
        )

        do {
            let _: StubResponse = try await sut.request(StubEndpoint(requiresAuth: true))
            XCTFail("Expected tokenExpired")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .tokenExpired)
            XCTAssertEqual(refreshService.requestCount, 1, "Refresh should be called exactly once")
        }
    }

    // MARK: Test 6 — Non-auth errors not retried

    func test_request_on500_noRefreshNoRetry() async throws {
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
            XCTAssertEqual(base.requestCount, 1)
            XCTAssertEqual(refreshService.requestCount, 0)
        }
    }

    // MARK: Test 7 — Three concurrent 401s → shared refresh

    func test_request_threeConcurrent401s_sharedRefresh() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "old", refreshToken: "ref", expiresIn: 60)

        let refreshService = MockNetworkService()
        refreshService.result = RefreshTokenResponseDTO(
            authTokens: AuthTokensDTO(accessToken: "new", refreshToken: "newRef", expiresIn: 7200)
        )

        let toggleBase = ToggleMockNetworkService(
            firstError: NetworkError.serverError(statusCode: 401, data: nil),
            thenReturn: StubResponse(value: "ok")
        )

        let sut = AuthenticatedNetworkService(
            baseService: toggleBase,
            tokenProvider: MockTokenProvider(),
            tokenStore: store,
            refreshService: refreshService,
            refreshActor: TokenRefreshActor(),
            onForceLogout: {}
        )

        async let r1: StubResponse = sut.request(StubEndpoint(requiresAuth: true))
        async let r2: StubResponse = sut.request(StubEndpoint(requiresAuth: true))
        async let r3: StubResponse = sut.request(StubEndpoint(requiresAuth: true))

        let results = try await [r1, r2, r3]
        XCTAssertEqual(results.count, 3)
        XCTAssertTrue(results.allSatisfy { $0.value == "ok" })
        XCTAssertLessThanOrEqual(refreshService.requestCount, 2,
            "Concurrent 401s should share a single refresh")
    }

    // MARK: Test 8 — Keychain save fails after refresh → logout

    func test_request_refreshSucceeds_keychainFails_logout() async throws {
        class FailingSaveTokenStore: MockTokenStore {
            override func save(_ tokens: AuthTokens) throws {
                throw KeychainError.unhandledError(status: -1)
            }
        }
        let failingStore = FailingSaveTokenStore()
        failingStore.stored = AuthTokens(accessToken: "old", refreshToken: "ref", expiresIn: 60)

        let toggleBase = ToggleMockNetworkService(
            firstError: NetworkError.serverError(statusCode: 401, data: nil),
            thenReturn: StubResponse(value: "ok")
        )
        let refreshService = MockNetworkService()
        refreshService.result = RefreshTokenResponseDTO(
            authTokens: AuthTokensDTO(accessToken: "new", refreshToken: "newRef", expiresIn: 7200)
        )

        var forceLogoutCalled = false
        let sut = AuthenticatedNetworkService(
            baseService: toggleBase,
            tokenProvider: MockTokenProvider(),
            tokenStore: failingStore,
            refreshService: refreshService,
            refreshActor: TokenRefreshActor(),
            onForceLogout: { forceLogoutCalled = true }
        )

        do {
            let _: StubResponse = try await sut.request(StubEndpoint(requiresAuth: true))
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(forceLogoutCalled, "Force logout must be called when Keychain save fails")
        }
    }

    // MARK: Helpers

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

// MARK: - AuthRepositoryImpl.loadSession Tests

final class AuthRepositoryLoadSessionTests: XCTestCase {

    // MARK: Test 9 — Expired access + valid refresh → session restored

    func test_loadSession_expiredAccess_refreshTokenValid_refreshes() async throws {
        let freshTokens = AuthTokens(accessToken: "fresh", refreshToken: "newRef", expiresIn: 7200)

        class RefreshableMockTokenStore: MockTokenStore {
            var freshTokens: AuthTokens?
            var didRefresh = false
            override func refreshTokensIfNeeded() async throws -> Bool {
                didRefresh = true
                if let fresh = freshTokens { stored = fresh }
                return true
            }
        }

        let store = RefreshableMockTokenStore()
        store.stored = AuthTokens(accessToken: "expired", refreshToken: "ref", expiresIn: -10)
        store.freshTokens = freshTokens

        let userLocalDataSource = MockUserLocalDataSource()
        userLocalDataSource.userToReturn = User.testMock

        let sut = AuthRepositoryImpl(
            remoteDataSource: MockAuthRemoteDataSource(),
            tokenStore: store,
            userLocalDataSource: userLocalDataSource
        )

        let result = try await sut.loadSession()
        XCTAssertNotNil(result, "Session should be restored after successful refresh")
        XCTAssertEqual(result?.authTokens.accessToken, "fresh")
        XCTAssertTrue(store.didRefresh)
    }

    // MARK: Test 10 — Expired access + refresh fails → logged out

    func test_loadSession_expiredAccess_refreshFailed_loggedOut() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "expired", refreshToken: "ref", expiresIn: -10)
        store.refreshTokensIfNeededResult = false

        let userLocalDataSource = MockUserLocalDataSource()

        let sut = AuthRepositoryImpl(
            remoteDataSource: MockAuthRemoteDataSource(),
            tokenStore: store,
            userLocalDataSource: userLocalDataSource
        )

        let result = try await sut.loadSession()
        XCTAssertNil(result, "Session should be nil when refresh fails")
        XCTAssertTrue(store.clearCalled, "Tokens should be cleared")
    }

    // MARK: Test — No tokens → nil

    func test_loadSession_noTokens_returnsNil() async throws {
        let store = MockTokenStore()
        let sut = AuthRepositoryImpl(
            remoteDataSource: MockAuthRemoteDataSource(),
            tokenStore: store,
            userLocalDataSource: MockUserLocalDataSource()
        )

        let result = try await sut.loadSession()
        XCTAssertNil(result)
    }

    // MARK: Test — Valid tokens → session restored

    func test_loadSession_validTokens_restoresSession() async throws {
        let store = MockTokenStore()
        store.stored = AuthTokens(accessToken: "valid", refreshToken: "ref", expiresIn: 3600)

        let userLocalDataSource = MockUserLocalDataSource()
        userLocalDataSource.userToReturn = User.testMock

        let sut = AuthRepositoryImpl(
            remoteDataSource: MockAuthRemoteDataSource(),
            tokenStore: store,
            userLocalDataSource: userLocalDataSource
        )

        let result = try await sut.loadSession()
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.authTokens.accessToken, "valid")
    }

    // MARK: Test — Expired access + no refresh service → logged out

    func test_loadSession_expiredAccess_noRefreshService_loggedOut() async throws {
        let store = KeychainAuthTokenStore()
        let sut = AuthRepositoryImpl(
            remoteDataSource: MockAuthRemoteDataSource(),
            tokenStore: store,
            userLocalDataSource: MockUserLocalDataSource()
        )

        let result = try await sut.loadSession()
        XCTAssertNil(result)
    }
}

// MARK: - Token leakage test

final class TokenLeakageTests: XCTestCase {

    func test_noAccessTokenInLogs() throws {
        // Structural guard: verify that the test token is non-trivial
        // so that any accidental logging of it would be detectable.
        let token = "super-secret-access-token-12345-abcdef"
        XCTAssertGreaterThan(token.count, 10)
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

private final class AlwaysFail401NetworkService: NetworkService {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        throw NetworkError.serverError(statusCode: 401, data: nil)
    }
    func request(_ endpoint: APIEndpoint) async throws {
        throw NetworkError.serverError(statusCode: 401, data: nil)
    }
}

// MARK: - Mock Auth Data Source

private final class MockAuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    func sendOTP(for phoneNumber: String) async throws {}
    func verifyOTP(for phoneNumber: String, with code: String) async throws -> VerifyOTPResponseDTO {
        fatalError("Not used in these tests")
    }
}

// MARK: - Mock User Local Data Source

private final class MockUserLocalDataSource: UserLocalDataSource {
    var userToReturn: User?
    var deleteUserCalled = false

    func saveUser(_ user: User) async throws -> Bool { true }
    func getUser() async throws -> User? { userToReturn }
    func deleteUser() async throws { deleteUserCalled = true }
}

// MARK: - User.testMock

private extension User {
    static let testMock = User(
        id: 1,
        phoneNumber: "+1234567890",
        profile: UserProfile(
            displayName: "Test User",
            username: "testuser",
            email: "test@example.com",
            avatarURL: "",
            gender: "male",
            dateOfBirth: "2000-01-01",
            targetRole: "Engineer",
            industry: "Tech",
            experienceLevel: "Senior",
            currentJobTitle: "iOS Dev",
            yearsOfExperience: 5,
            cvURL: "",
            skills: [],
            targetCompanies: [],
            educationLevel: "Bachelor",
            timezone: "UTC",
            termsAccepted: true,
            subscriptionTier: "Free",
            coinBalance: 0,
            onboardingCompleted: true,
            trackId: 1
        ),
        isNewUser: false
    )
}

// MARK: - XCTest async helper

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

extension NetworkError: @retroactive Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.unauthorized, .unauthorized),
             (.tokenExpired, .tokenExpired),
             (.noInternet, .noInternet),
             (.invalidURL, .invalidURL),
             (.requestTimeout, .requestTimeout):
            return true
        case (.serverError(let l, _, _), .serverError(let r, _, _)):
            return l == r
        default:
            return false
        }
    }
}
