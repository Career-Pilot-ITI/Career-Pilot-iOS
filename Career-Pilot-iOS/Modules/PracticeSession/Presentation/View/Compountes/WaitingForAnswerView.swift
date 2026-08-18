//
//  WaitingForAnswerView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

struct WaitingForAnswerView: View {
    @ObservedObject var vm: PracticeSessionViewModel

    var body: some View {
        VStack(spacing: Spacing.s32) {
            SessionHeader(vm: vm){
                Task{
                    await vm.finish()
                }
            }

            Spacer()

            WaitingStateView(
                icon: "mic.fill",
                tint: .primary, 
                state: .success,
                title: "Your Turn"
            )

            Spacer()

            QuestionCard(text: vm.currentQuestionText)

            CustomButton(buttonTitle: "Start Answering") {
                vm.startAnswering()
            }
        }
        .padding(.horizontal, Spacing.s20)
        .padding(.top, Spacing.s16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
    }
}
