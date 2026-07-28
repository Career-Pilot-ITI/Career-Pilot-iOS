//
//  PhoneValidationState.swift
//  Career-Pilot-iOS
//
//  Created on 28/07/2026.
//

import SwiftUI

enum PhoneValidationState: Equatable {
    case idle
    case empty
    case tooShort
    case invalidPrefix
    case valid

    var message: String {
        switch self {
        case .idle:
            return "Enter your phone number to continue"
        case .empty:
            return "Please enter your phone number"
        case .tooShort:
            return "Phone number looks too short"
        case .invalidPrefix:
            return "Phone number should start with a valid mobile prefix"
        case .valid:
            return "Looks good ✓"
        }
    }

    var color: Color {
        switch self {
        case .idle:
            return Color.gray400
        case .empty, .tooShort, .invalidPrefix:
            return AppColors.error
        case .valid:
            return AppColors.success
        }
    }
}
