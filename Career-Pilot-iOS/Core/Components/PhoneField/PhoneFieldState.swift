//
//  PhoneFieldState.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import SwiftUI

enum PhoneFieldState: Equatable {
    case idle
    case focused
    case valid
    case invalid
    case disabled
    case loading

    var borderColor: Color {
        
        switch self {
        case .idle: return AppColors.PhoneField.borderIdle
        case .focused: return AppColors.PhoneField.borderFocused
        case .valid: return AppColors.PhoneField.borderValid
        case .invalid: return AppColors.PhoneField.borderInvalid
        case .disabled: return AppColors.PhoneField.borderDisabled
        case .loading: return AppColors.PhoneField.borderIdle
        }
    }

    var borderWidth: CGFloat {
        
        switch self {
        case .focused, .invalid, .valid: return 1.5
        default: return 1
        }
    }

    var iconColor: Color {
        switch self {
        case .valid: return AppColors.PhoneField.iconValid
        case .invalid: return AppColors.PhoneField.iconInvalid
        default: return AppColors.PhoneField.iconDefault
        }
    }
}
