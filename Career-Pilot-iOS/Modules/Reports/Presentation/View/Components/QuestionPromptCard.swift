//
//  QuestionPromptCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct QuestionPromptCard: View {
    let questionNumber: Int
    let questionText: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text("QUESTION \(questionNumber)")
                .font(Font.size12Bold)
                .foregroundStyle(Color.gray400)

            Text(questionText)
                .font(Font.size16Bold)
                .foregroundStyle(Color.primaryNavy)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(.white)
        }
    }
}

//#Preview {
//    QuestionPromptCard(questionNumber: 2, questionText: "Tell me about yourself and your background.")
//}
