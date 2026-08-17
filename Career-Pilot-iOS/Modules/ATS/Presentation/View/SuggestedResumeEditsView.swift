//
//  SuggestedResumeEditsView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//

import SwiftUI

struct SuggestedResumeEditsView: View {
    let jobMatch: JobMatch

    // Hook these up to your view model / coordinator.
    var onApplyEdits: () -> Void = {}
    var onGenerateCoverLetter: () -> Void = {}
    var onStartPractice: () -> Void = {}

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Suggested Resume Edits")
                        .font(Font.size14Bold)
                        .foregroundColor(Color.textPrimary)

                    VStack(spacing: 12) {
                        ForEach(jobMatch.suggestedEdits) { edit in
                            SuggestedEditCard(edit: edit)
                        }
                    }

                    VStack(spacing: 12) {
                        Button(action: onApplyEdits) {
                            IconLabelButton(systemImage: "pencil", title: "Apply Suggested Edits")
                        }
                        .buttonStyle(PrimaryActionButtonStyle())

                        Button(action: onGenerateCoverLetter) {
                            IconLabelButton(systemImage: "envelope", title: "Generate Cover Letter")
                        }
                        .buttonStyle(OutlineActionButtonStyle())

                        Button(action: onStartPractice) {
                            IconLabelButton(systemImage: "mic.fill", title: "Start Practice Session for this job")
                        }
                        .buttonStyle(OutlineActionButtonStyle(tint: Color.accentOrange))
                    }
                    .padding(.top, 4)
                }
                .padding(16)
            }
            .scrollIndicators(.hidden)
            .background(Color.lightBackGround.ignoresSafeArea())
            .navigationTitle("Job Match")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    NavigationStack {
//        SuggestedResumeEditsView(jobMatch: .mock)
//    }
//}
