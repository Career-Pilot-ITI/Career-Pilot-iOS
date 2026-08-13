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
            ZStack{
                
                RoundedRectangle(cornerRadius: Radius.r8)
                    .fill(Color.primary.opacity(3))
                    .frame(width: 25, height: 25)

                Image("sparkles")
                    .font(.system(size: 16, weight: .semibold))
            }

            Text("Your first session is on us — no card needed!")
                .font(.size13Semibold)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.vertical, Spacing.s16)
        .background(
            RoundedRectangle(cornerRadius: Radius.r12)
                .fill(Color.primary.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.r12)
                .stroke(Color.primary.opacity(0.25), lineWidth: 1)
        )
    }
}
