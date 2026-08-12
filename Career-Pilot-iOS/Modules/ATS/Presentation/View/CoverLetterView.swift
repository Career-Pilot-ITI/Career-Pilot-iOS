//
//  CoverLetterView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import SwiftUI

struct CoverLetterView: View {
    let data: CoverLetterData
    var onBack: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: Radius.r16) {
                    CoverLetterCardView(data: data)
                    NextStepsCard(steps: data.nextSteps)
                    SendEmailButton()
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Color.screenBackground.ignoresSafeArea())
    }
}

#Preview {
    CoverLetterView(data: .sample)
}
