//
//  SwiftUIView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct FreeSessionBanner: View {
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image("sparkles")
                .foregroundColor(.activeColour)
                .font(.system(size: 16, weight: .semibold))

            Text("Your first session is on us — no card needed!")
                .font(.bodySmallSemiBold)
                .foregroundColor(.activeColour)

            Spacer()
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Radius.lg)
                .fill(Color.activeColour.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Color.activeColour.opacity(0.25), lineWidth: 1)
        )
    }
}
