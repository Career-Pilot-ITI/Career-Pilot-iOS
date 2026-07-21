//
//  RecordingView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

struct RecordingView: View {
    @ObservedObject var vm: PracticeSessionViewModel
    let silenceWarning: SilenceWarning?

    var body: some View {
        VStack(spacing: Spacing.s24) {
            SessionHeader(
                questionNumber: vm.currentQuestionNumber,
                totalQuestions: vm.totalQuestions
            )

            if let silenceWarning {
                SilenceWarningBanner(remainingSeconds: silenceWarning.remainingSeconds) {
                    vm.submitAnswerManually()
                }
            }

            Spacer()

            WaitingStateView(
                icon: "mic.fill",
                tint: .primary,
                state: .recording,
                title: elapsedTimeText
            )

            SoundWaveView(color: .primary)

            Spacer()

            QuestionCard(text: vm.currentQuestionText)

            CustomButton(showArrow: false, buttonTitle: "Submit Answering") {
                vm.submitAnswerManually()
            }
        }
        .padding(.horizontal, Spacing.s20)
        .padding(.top, Spacing.s16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkBackGround.ignoresSafeArea())
        .animation(.easeInOut, value: silenceWarning)
    }

    private var elapsedTimeText: String {
        let minutes = Int(vm.elapsedRecordingTime) / 60
        let seconds = Int(vm.elapsedRecordingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


private struct SilenceWarningBanner: View {
    let remainingSeconds: Int
    let onKeepGoing: () -> Void

    var body: some View {
        HStack(spacing: Spacing.s12) {
            Image(systemName: "waveform.slash")
                .foregroundStyle(AppColors.warning)

            VStack(alignment: .leading, spacing: 2) {
                Text("Silence detected")
                    .font(.size13Semibold)
                    .foregroundStyle(Color.gray100)
                Text("Moving to next question in \(remainingSeconds)s")
                    .font(.size12Regular)
                    .foregroundStyle(Color.gray400)
            }

            Spacer()

            Button("Keep going", action: onKeepGoing)
                .font(.size13Semibold)
                .foregroundStyle(AppColors.warning)
        }
        .padding(Spacing.s12)
        .background {
            RoundedRectangle(cornerRadius: Radius.r12)
                .fill(AppColors.warning.opacity(0.12))
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
