//
//  Colors.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 14/07/2026.
//

import SwiftUI

enum AppColors {

    // MARK: - Brand

    static let accent = Color("AccentColor")          
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary

    // MARK: - Semantic / status colors

    static let success = Color("SuccessGreen", bundle: nil, fallback: Color(hex: "34C759"))
    static let error   = Color("ErrorRed", bundle: nil, fallback: Color(hex: "FF3B30"))
    static let warning = Color("WarningYellow", bundle: nil, fallback: Color(hex: "FFCC00"))

    // MARK: - Field-specific

    enum PhoneField {
        static let borderIdle = Color.gray.opacity(0.4)
        static let borderFocused = AppColors.accent
        static let borderValid = AppColors.success
        static let borderInvalid = AppColors.error
        static let borderDisabled = Color.gray.opacity(0.2)

        static let background = Color("NavyMid")
        static let backgroundDisabled = Color.gray.opacity(0.06)

        static let iconValid = AppColors.success
        static let iconInvalid = AppColors.error
        static let iconDefault = AppColors.secondaryText
    }
    
    enum OTPField {
        static let otpBackground    = Color.darkBackGround
        static let otpBoxEmpty      = Color("NavyMid")
        static let otpBoxFilled     = Color.activeColour
        static let otpAccent        = Color.primaryTeal
        static let otpSecondaryText = Color.gray400
    }
}

extension Color {
   static let darkBackGround = Color("NavyDark")
   static let lightBackGround = Color("Background")
   static let successColour = Color("Success")
   static let errorColour = Color("Error")
   static let gray100 = Color("Gray100")
   static let gray200 = Color("Gray200")
   static let gray400 = Color("Gray400")
   static let gray600 = Color("Gray600")
   static let primaryYellow = Color("Yellow")
   static let activeColour = Color("Amber")
   static let primaryTeal = Color("Teal")
   static let primaryTealLight = Color("TealLight")
   static let primaryNavy = Color("PrimaryNavy")
    

    
  }





