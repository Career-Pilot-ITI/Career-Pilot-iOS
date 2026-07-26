//
//  PhoneValidator.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import Foundation

struct PhoneValidator {
    
    static func isValid(number: String, for country: CountryCode) -> Bool {
        let digits = number.filter(\.isNumber)
        return digits.count == country.maxLength
    }
    
    static func format(_ raw: String) -> String {
        let digits = raw.filter(\.isNumber)
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
