//
//  AITurnView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

struct AITurnView: View {
    @ObservedObject var vm: PracticeSessionViewModel
    
    var body: some View {
        VStack(spacing: Spacing.s32) {
            SessionHeader(vm: vm)
            
            Spacer()
            
            WaitingStateView(
                icon: "headphones",
                tint: .primaryTeal,
                state: .listening,
                title: "AI Coach Speaking"
            )
            
            SoundWaveView(color: .primaryTeal)
            
            Spacer()
            
            QuestionCard(text: vm.currentQuestionText)
        }
        .padding(.horizontal, Spacing.s20)
        .padding(.top, Spacing.s16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
    }
}
