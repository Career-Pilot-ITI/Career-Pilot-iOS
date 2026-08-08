//
//  StatusScreens.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

/// "Submitting your answer... Preparing next question" — matches the screenshot.
struct SubmittingAnswerView: View {
    var body: some View {
        VStack {
            Spacer()
            WaitingStateView(
                icon: "bolt.fill",
                tint: .primary, // orange
                state: .loading,
                title: "Submitting your answer…",
                subtitle: "Preparing next question"
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkBackGround.ignoresSafeArea())
    }
}

/// Shown while resuming after a network drop.
struct ReconnectingView: View {
    var body: some View {
        VStack {
            Spacer()
            WaitingStateView(
                icon: "wifi.exclamationmark",
                tint: .primaryTeal,
                state: .loading,
                title: "Reconnecting…",
                subtitle: "Picking up where you left off"
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkBackGround.ignoresSafeArea())
    }
}

/// Generic error state with a retry affordance.
struct SessionErrorView: View {
    let errorMessage: String
    var onRetry: (() -> Void)? = nil
    var onEndTapped: (() -> Void)

    var body: some View {
        VStack {
            HStack{
                Spacer()
                
                Button("End", action: onEndTapped)
                    .font(.size13Semibold)
                    .foregroundStyle(Color.errorColour)
            }
            .padding(.trailing, 25)

            Spacer()
            WaitingStateView(
                icon: "exclamationmark.triangle.fill",
                tint: .errorColour,
                state: .failure,
                title: "Something went wrong",
                subtitle: errorMessage,
                actionTitle: onRetry != nil ? "Try Again" : nil,
                action: onRetry
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkBackGround.ignoresSafeArea())
    }
}


struct SessionCompletedView: View {
    let feedback: InterviewFeedback

    var body: some View {
        VStack {
            Spacer()
            WaitingStateView(
                icon: "checkmark",
                tint: .successColour,
                state: .success,
                title: "Interview Complete",
                subtitle: "Overall score: \(String(format: "%.1f", feedback.overallScore))/10")
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkBackGround.ignoresSafeArea())
    }
}
