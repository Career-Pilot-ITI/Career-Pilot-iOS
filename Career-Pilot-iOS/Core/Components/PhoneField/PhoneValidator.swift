//
//  PhoneValidator.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

//
//  PhoneValidator.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import Foundation

struct PhoneValidator {
    
    /// Helper to extract clean digits and strip any leading zero
    private static func cleanDigits(_ input: String) -> String {
        var digits = input.filter(\.isNumber)
        if digits.hasPrefix("0") {
            digits.removeFirst()
        }
        return digits
    }
    
    static func isValid(number: String, for country: CountryCode) -> Bool {        
        let digits = cleanDigits(number)
        return validate(number: number, for: country) == .valid && digits.count == country.maxLength
    }
    
    static func format(_ raw: String) -> String {
        let digits = cleanDigits(raw)
        var result = ""
        for (index, char) in digits.enumerated() {
            if index == 3 || index == 6 {
                result += " "
            }
            result.append(char)
        }
        return result
    }

    // MARK: - Detailed Validation

    static func validate(number: String, for country: CountryCode) -> PhoneValidationState {
        let digits = cleanDigits(number)

        if digits.isEmpty {
            return .empty
        }

        if digits.count < country.maxLength {
            return .tooShort
        }

        if country.dialCode == "+20" {
            let validEgyptianPrefixes = ["10", "11", "12", "15"]
            let prefix = String(digits.prefix(2))
            if !validEgyptianPrefixes.contains(prefix) {
                return .invalidPrefix
            }
        }

        return .valid
    }
}
