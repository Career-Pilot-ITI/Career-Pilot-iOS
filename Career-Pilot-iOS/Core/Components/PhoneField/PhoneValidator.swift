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
        return digits.count == country.maxLength
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
}
