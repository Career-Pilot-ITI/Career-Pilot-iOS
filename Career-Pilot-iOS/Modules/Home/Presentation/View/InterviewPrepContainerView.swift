//
//  InterviewPrepContainerView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//

import SwiftUI

struct InterviewPrepContainerView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @State private var micGranted = false
    let trackName: String
    let interviewTime : Int
    let quetionsCount : Int
    
    var body: some View {
        PracticePreparationView(
            categoryText: trackName,
            metadataText: "\(quetionsCount) Questions · ~\(interviewTime)min",
            title: "Ready to practice?",
            subtitle: "Before we begin, a few quick tips.",
            tips: [
                PracticeTip(stepNumber: "1", text: "Find a quiet space with minimal background noise"),
                PracticeTip(stepNumber: "2", text: "Speak clearly and at a natural pace"),
                PracticeTip(stepNumber: "3", text: "Take time to gather your thoughts before answering"),
                PracticeTip(stepNumber: "4", text: "The AI will wait for you to finish before responding")
            ],
            isMicrophoneGranted: $micGranted,
            accentColor: .orange,
            onCancel: {
                print("Cancel tapped")
                coordinator.pop()
            },
            onBegin: {
                print("Begin interview tapped")
            }
        ).navigationBarHidden(true)
    }
}

#Preview {
    InterviewPrepContainerView(trackName: "SoftWare Engineering", interviewTime: 30, quetionsCount: 8)
}
