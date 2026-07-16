//
//  SwiftUIView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct FreeSessionBanner: View {
    var body: some View {
        HStack(spacing: Spacing.s8) {
            Image("sparkles")
                .foregroundColor(.activeColour)
                .font(.system(size: 16, weight: .semibold))

            Text("Your first session is on us — no card needed!")
                .font(.bodySmallSemiBold)
                .foregroundColor(.activeColour)

            Spacer()
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.vertical, Spacing.s16)
        .background(
            RoundedRectangle(cornerRadius: Radius.r12)
                .fill(Color.activeColour.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.r12)
                .stroke(Color.activeColour.opacity(0.25), lineWidth: 1)
        )
    }
}
