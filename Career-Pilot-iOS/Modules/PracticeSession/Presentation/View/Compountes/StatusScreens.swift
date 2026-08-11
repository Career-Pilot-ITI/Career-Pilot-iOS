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

struct SessionErrorView: View {
    let errorMessage: String
    var onRetry: (() -> Void)? = nil
    var onEndTapped: (() -> Void)

    @State private var showEndConfirmation = false

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Button {
                    showEndConfirmation = true
                } label: {
                    Label("End", systemImage: "xmark")
                        .font(.size13Semibold)
                        .labelStyle(.titleAndIcon)
                        .foregroundStyle(Color.errorColour)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.errorColour.opacity(0.12))
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.errorColour.opacity(0.3), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 12)
            .padding(.horizontal, 20)

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
        .confirmationDialog(
            "End this session?",
            isPresented: $showEndConfirmation,
            titleVisibility: .visible
        ) {
            Button("End Session", role: .destructive) {
                onEndTapped()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will stop the current session and you won't be able to resume it.")
        }
    }
}

struct SessionCompletedView: View {
    let feedback: InterviewFeedback
    let sessionID: Int
    @EnvironmentObject private var homeCoordinator: AppCoordinator<HomeRoute>



    var body: some View {
        VStack (spacing: 20) {
            BackButton(text: "Home")
                .onTapGesture {
                    homeCoordinator.popToRoot()
                }
            
            Spacer()
            WaitingStateView(
                icon: "checkmark",
                tint: .successColour,
                state: .success,
                title: "Interview Complete",
                subtitle: "Overall score: \(String(format: "%.1f", feedback.overallScore))/10")
            
            CustomButton(buttonTitle: "For More Details"){
                homeCoordinator.push(.sessionFeedback(feedback: feedback, sessionId: sessionID))
            }
            Spacer()
        }
//        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkBackGround.ignoresSafeArea())
    }
}

struct SessionCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        SessionCompletedView(
            feedback: .empty,
            sessionID: 4
        )
        .environmentObject(AppCoordinator<HomeRoute>())
    }
}
