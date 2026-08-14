//
//  SessionHeader.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

struct SessionHeader: View {

    @StateObject var vm: PracticeSessionViewModel
    var onEndTapped: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text("Q \(vm.currentQuestionNumber)/\(vm.totalQuestions)")
                .font(.size13Semibold)
                .foregroundStyle(Color.gray400)
                .padding(.horizontal, Spacing.s12)
                .padding(.vertical, Spacing.s4)
                .background {
                    Capsule().fill(Color.gray600.opacity(0.3))
                }

            Spacer()

            Text(elapsedTimeText)
                .foregroundColor(Color.gray100)

            Spacer()

            if let onEndTapped {
                SessionNavButton(action: .endSession, style: .compact, onConfirm: onEndTapped)
            }
        }
    }

    private var elapsedTimeText: String {
        let minutes = Int(vm.elapsedSessionTime) / 60
        let seconds = Int(vm.elapsedSessionTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct QuestionCard: View {
    let text: String

    private let minCardHeight: CGFloat = 100
    private let maxCardHeight: CGFloat = 220

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text("QUESTION")
                .font(.size12Semibold)

            ScrollView(showsIndicators: false) {
                Text(text)
                    .font(.size14Regular)
                    .foregroundStyle(Color.gray100)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(minHeight: minCardHeight, maxHeight: maxCardHeight)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.s16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color.primary)
        }
    }
}
