//
//  SessionHeader.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI


struct SessionHeader: View {
    let questionNumber: Int
    let totalQuestions: Int
    var onEndTapped: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text("Q \(questionNumber)/\(totalQuestions)")
                .font(.size13Semibold)
                .foregroundStyle(Color.gray400)
                .padding(.horizontal, Spacing.s12)
                .padding(.vertical, Spacing.s4)
                .background {
                    Capsule().fill(Color.gray600.opacity(0.3))
                }

            Spacer()

            if let onEndTapped {
                Button("End", action: onEndTapped)
                    .font(.size13Semibold)
                    .foregroundStyle(Color.errorColour)
            }
        }
    }
}


struct QuestionCard: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text("QUESTION")
                .font(.size12Semibold)
                .foregroundStyle(Color.gray400)

            Text(text)
                .font(.size14Regular)
                .foregroundStyle(Color.gray100)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.s16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color.primaryNavy)
        }
    }
}
