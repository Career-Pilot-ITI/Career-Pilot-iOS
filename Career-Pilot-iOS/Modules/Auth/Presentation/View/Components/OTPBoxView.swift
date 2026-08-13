//
//  OTPBoxView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 14/07/2026.
//

import SwiftUI

struct OTPBoxView: View {
    let character: String
    let isActive: Bool

    private var isFilled: Bool { !character.isEmpty }

    var body: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(isFilled ? AppColors.OTPField.otpBoxFilled : AppColors.OTPField.otpBoxEmpty.opacity(0.6))
            .frame(width: 48, height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isActive ? Color.primary.opacity(0.6) : Color.clear, lineWidth: 1.5)
            )
            .overlay(
                Text(character)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
            )
            .animation(.easeOut(duration: 0.15), value: isFilled)
    }
}

struct OTPBoxViewPreview : PreviewProvider {
    static var previews: some View {
        OTPBoxView(character: "", isActive: true)
            .previewDisplayName("OTP Box")
    }
}
