//
//  ActionButtonsView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.


import SwiftUI

struct ActionButtonsView: View {
    var onApplyEdits: () -> Void = {}
    var onGenerateCoverLetter: () -> Void = {}
    var onStartPractice: () -> Void = {}

    var body: some View {
        VStack(spacing: 12) {
            Button(action: onApplyEdits) {
                Label("Apply Suggested Edits", systemImage: "pencil")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .background(Color.primary)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Button(action: onGenerateCoverLetter) {
                Label("Generate Cover Letter", systemImage: "envelope")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            )

            Button(action: onStartPractice) {
                Label("Start Practice Session for this job", systemImage: "mic")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            )
        }
    }
}

#Preview {
    ActionButtonsView()
        .padding()
        .background(Color.screenBackground)
}
