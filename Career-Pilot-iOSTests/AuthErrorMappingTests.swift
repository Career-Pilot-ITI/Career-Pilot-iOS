//
//  AuthErrorMappingTests.swift
//  Career-Pilot-iOSTests
//
//  Created on 28/07/2026.
//

import XCTest
@testable import Career_Pilot_iOS

final class AuthErrorMappingTests: XCTestCase {

    // MARK: - userMessage Tests

    func testBadRequest400_returnsInvalidInputMessage() {
        let error = NetworkError.serverError(statusCode: 400, data: nil)
        XCTAssertEqual(error.userMessage, "The information you entered doesn't look right. Please check and try again.")
    }

    func testUnauthorized401_returnsExpiredCodeMessage() {
        let error = NetworkError.serverError(statusCode: 401, data: nil)
        XCTAssertEqual(error.userMessage, "Your code is invalid or has expired. Please request a new one.")
    }

    func testForbidden403_returnsRestrictedMessage() {
        let error = NetworkError.serverError(statusCode: 403, data: nil)
        XCTAssertEqual(error.userMessage, "Access to this account is currently restricted. Please contact support.")
    }

    func testNotFound404_returnsNotFoundMessage() {
        let error = NetworkError.serverError(statusCode: 404, data: nil)
        XCTAssertEqual(error.userMessage, "We couldn't find an account with this information.")
    }

    func testConflict409_returnsAlreadyRegisteredMessage() {
        let error = NetworkError.serverError(statusCode: 409, data: nil)
        XCTAssertEqual(error.userMessage, "This phone number is already registered, or the code has already been used.")
    }

    func testUnprocessable422_returnsValidationMessage() {
        let error = NetworkError.serverError(statusCode: 422, data: nil)
        XCTAssertEqual(error.userMessage, "Some of the information provided is invalid. Please review and try again.")
    }

    func testRateLimit429_withoutRetryAfter_returnsGenericWaitMessage() {
        let error = NetworkError.serverError(statusCode: 429, data: nil)
        XCTAssertEqual(error.userMessage, "You've made too many attempts. Please wait a moment and try again.")
    }

    func testRateLimit429_withRetryAfter_includesSeconds() {
        let json = #"{"retryAfter": 45}"#
        let data = json.data(using: .utf8)
        let error = NetworkError.serverError(statusCode: 429, data: data)
        XCTAssertEqual(error.userMessage, "You've made too many attempts. Please try again in 45 seconds.")
    }

    func testRateLimit429_withZeroRetryAfter_returnsGenericWaitMessage() {
        let json = #"{"retryAfter": 0}"#
        let data = json.data(using: .utf8)
        let error = NetworkError.serverError(statusCode: 429, data: data)
        XCTAssertEqual(error.userMessage, "You've made too many attempts. Please wait a moment and try again.")
    }

    func testServerError500_returnsServerIssueMessage() {
        let error = NetworkError.serverError(statusCode: 500, data: nil)
        XCTAssertEqual(error.userMessage, "Our servers are experiencing issues. Please try again in a moment.")
    }

    func testServerError502_returnsServerIssueMessage() {
        let error = NetworkError.serverError(statusCode: 502, data: nil)
        XCTAssertEqual(error.userMessage, "Our servers are experiencing issues. Please try again in a moment.")
    }

    func testServerError503_returnsServerIssueMessage() {
        let error = NetworkError.serverError(statusCode: 503, data: nil)
        XCTAssertEqual(error.userMessage, "Our servers are experiencing issues. Please try again in a moment.")
    }

    func testServerError504_returnsServerIssueMessage() {
        let error = NetworkError.serverError(statusCode: 504, data: nil)
        XCTAssertEqual(error.userMessage, "Our servers are experiencing issues. Please try again in a moment.")
    }

    func testNoInternet_returnsConnectionMessage() {
        let error = NetworkError.noInternet
        XCTAssertEqual(error.userMessage, "No internet connection. Please check your network and try again.")
    }

    func testRequestTimeout_returnsTimeoutMessage() {
        let error = NetworkError.requestTimeout
        XCTAssertEqual(error.userMessage, "The request timed out. Please check your connection and try again.")
    }

    func testUnknownStatusCode_returnsGenericMessage() {
        let error = NetworkError.serverError(statusCode: 418, data: nil)
        XCTAssertEqual(error.userMessage, "Something went wrong. Please try again.")
    }

    func testUnknownError_returnsGenericMessage() {
        let error = NetworkError.unknown(NSError(domain: "test", code: -1))
        XCTAssertEqual(error.userMessage, "Something went wrong. Please try again.")
    }

    // MARK: - isRetryable Tests

    func testNoInternet_isRetryable() {
        XCTAssertTrue(NetworkError.noInternet.isRetryable)
    }

    func testRequestTimeout_isRetryable() {
        XCTAssertTrue(NetworkError.requestTimeout.isRetryable)
    }

    func test429_isRetryable() {
        XCTAssertTrue(NetworkError.serverError(statusCode: 429, data: nil).isRetryable)
    }

    func test500_isRetryable() {
        XCTAssertTrue(NetworkError.serverError(statusCode: 500, data: nil).isRetryable)
    }

    func test401_isNotRetryable() {
        XCTAssertFalse(NetworkError.serverError(statusCode: 401, data: nil).isRetryable)
    }

    func test403_isNotRetryable() {
        XCTAssertFalse(NetworkError.serverError(statusCode: 403, data: nil).isRetryable)
    }

    func testInvalidURL_isNotRetryable() {
        XCTAssertFalse(NetworkError.invalidURL.isRetryable)
    }

    // MARK: - No Raw Codes in Messages

    func testUserMessages_neverContainRawStatusCodes() {
        let codes = [400, 401, 403, 404, 409, 422, 429, 500, 502, 503, 504]
        for code in codes {
            let error = NetworkError.serverError(statusCode: code, data: nil)
            let message = error.userMessage
            XCTAssertFalse(message.contains("\(code)"), "userMessage for \(code) should not contain the raw status code")
        }
    }
}
