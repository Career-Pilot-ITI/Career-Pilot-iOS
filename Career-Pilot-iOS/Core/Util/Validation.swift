//
//  Validation.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 21/07/2026.
//

import Foundation

final class InputValidator {
    
    // MARK: - Email
    
    static func isValidEmail(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        
        // Standard RFC-5322-ish pattern: local@domain.tld
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: trimmed)
    }
    
    // MARK: - Phone Number
    
    static func isValidPhoneNumber(_ phone: String) -> Bool {
        let trimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        
        // Must not start with 0, and must be all digits (adjust length as needed)
        let phoneRegex = #"^[1-9][0-9]{6,14}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: trimmed)
    }
}
