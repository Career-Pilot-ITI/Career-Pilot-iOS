//
//  PhoneValidationTests.swift
//  Career-Pilot-iOSTests
//
//  Created on 28/07/2026.
//

import XCTest
@testable import Career_Pilot_iOS

final class PhoneValidationTests: XCTestCase {

    private let egypt = CountryCode(flag: "🇪🇬", dialCode: "+20", name: "Egypt", maxLength: 10)
    private let us = CountryCode(flag: "🇺🇸", dialCode: "+1", name: "United States", maxLength: 10)

    // MARK: - Empty Input

    func testEmptyInput_returnsEmpty() {
        let result = PhoneValidator.validate(number: "", for: egypt)
        XCTAssertEqual(result, .empty)
    }

    func testWhitespaceOnly_returnsEmpty() {
        let result = PhoneValidator.validate(number: "   ", for: egypt)
        XCTAssertEqual(result, .empty)
    }

    // MARK: - Too Short

    func testTooShort_oneDigit_returnsTooShort() {
        let result = PhoneValidator.validate(number: "1", for: egypt)
        XCTAssertEqual(result, .tooShort)
    }

    func testTooShort_nineDigits_returnsTooShort() {
        let result = PhoneValidator.validate(number: "105538504", for: egypt)
        XCTAssertEqual(result, .tooShort)
    }

    // MARK: - Invalid Egyptian Prefix

    func testEgypt_invalidPrefix13_returnsInvalidPrefix() {
        // "13" is not a valid Egyptian mobile prefix
        let result = PhoneValidator.validate(number: "1355385044", for: egypt)
        XCTAssertEqual(result, .invalidPrefix)
    }

    func testEgypt_invalidPrefix14_returnsInvalidPrefix() {
        let result = PhoneValidator.validate(number: "1455385044", for: egypt)
        XCTAssertEqual(result, .invalidPrefix)
    }

    func testEgypt_invalidPrefix16_returnsInvalidPrefix() {
        let result = PhoneValidator.validate(number: "1655385044", for: egypt)
        XCTAssertEqual(result, .invalidPrefix)
    }

    // MARK: - Valid Egyptian Prefixes

    func testEgypt_validPrefix10_returnsValid() {
        let result = PhoneValidator.validate(number: "1055385044", for: egypt)
        XCTAssertEqual(result, .valid)
    }

    func testEgypt_validPrefix11_returnsValid() {
        let result = PhoneValidator.validate(number: "1155385044", for: egypt)
        XCTAssertEqual(result, .valid)
    }

    func testEgypt_validPrefix12_returnsValid() {
        let result = PhoneValidator.validate(number: "1255385044", for: egypt)
        XCTAssertEqual(result, .valid)
    }

    func testEgypt_validPrefix15_returnsValid() {
        let result = PhoneValidator.validate(number: "1553850440", for: egypt)
        XCTAssertEqual(result, .valid)
    }

    // MARK: - Leading Zero Stripping

    func testEgypt_leadingZero_strippedAndValidated() {
        // "01055385044" → strip leading 0 → "1055385044" (10 digits, prefix 10)
        let result = PhoneValidator.validate(number: "01055385044", for: egypt)
        XCTAssertEqual(result, .valid)
    }

    // MARK: - US Numbers (no prefix validation)

    func testUS_validLength_returnsValid() {
        let result = PhoneValidator.validate(number: "2025551234", for: us)
        XCTAssertEqual(result, .valid)
    }

    func testUS_tooShort_returnsTooShort() {
        let result = PhoneValidator.validate(number: "202555", for: us)
        XCTAssertEqual(result, .tooShort)
    }

    // MARK: - isValid (existing method)

    func testIsValid_correctLength_returnsTrue() {
        XCTAssertTrue(PhoneValidator.isValid(number: "1553850440", for: egypt))
    }

    func testIsValid_wrongLength_returnsFalse() {
        XCTAssertFalse(PhoneValidator.isValid(number: "15538", for: egypt))
    }
}
