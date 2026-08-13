//
//  Validator.swift
//  Career-Pilot-iOS
//

import Foundation

enum Validator {
    
    // MARK: - Field-level checks (pure, reusable, no knowledge of any specific screen/model)
    
    static func isValidEmail(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: trimmed)
    }
    
    static func isValidPhoneNumber(_ phone: String) -> Bool {
        let trimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        let phoneRegex = #"^[1-9][0-9]{6,14}$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: trimmed)
    }
    
    static func isNotEmpty(_ text: String) -> Bool {
        !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    static func isWithinLength(_ text: String, max: Int) -> Bool {
        text.trimmingCharacters(in: .whitespaces).count <= max
    }
}
