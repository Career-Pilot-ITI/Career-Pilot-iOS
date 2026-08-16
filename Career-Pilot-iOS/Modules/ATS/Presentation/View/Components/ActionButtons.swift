//
//  ActionButtons.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//

import SwiftUI

struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.accentOrange)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct OutlineActionButtonStyle: ButtonStyle {
    var tint: Color = Color.textPrimary

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(tint)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.separator, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

struct IconLabelButton: View {
    let systemImage: String
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
            Text(title)
        }
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }
}

//#Preview {
//    VStack(spacing: 12) {
//        Button { } label: { IconLabelButton(systemImage: "pencil", title: "Apply Suggested Edits") }
//            .buttonStyle(PrimaryActionButtonStyle())
//        Button { } label: { IconLabelButton(systemImage: "envelope", title: "Generate Cover Letter") }
//            .buttonStyle(OutlineActionButtonStyle())
//        Button { } label: { IconLabelButton(systemImage: "mic.fill", title: "Start Practice Session for this job") }
//            .buttonStyle(OutlineActionButtonStyle(tint: Color.accentOrange))
//    }
//    .padding()
//}
