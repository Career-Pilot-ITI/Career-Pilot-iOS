//
//  StatusScreens.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

enum SessionNavAction: Equatable {
    case home
    case endSession

    var title: String {
        switch self {
        case .home: return "Home"
        case .endSession: return "End"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .endSession: return "xmark"
        }
    }

    var tint: Color {
        switch self {
        case .home: return .successColour
        case .endSession: return .errorColour
        }
    }

    var confirmationTitle: String {
        switch self {
        case .home: return "Leave this session?"
        case .endSession: return "End this session?"
        }
    }

    var confirmationMessage: String {
        switch self {
        case .home:
            return "You'll be taken back to Home. You can resume this session later from where you left off."
        case .endSession:
            return "This will stop the current session and you won't be able to resume it."
        }
    }

    var confirmButtonTitle: String {
        switch self {
        case .home: return "Go Home"
        case .endSession: return "End Session"
        }
    }

    var isDestructive: Bool {
        self == .endSession
    }
}


struct SessionNavButton: View {
    enum Style {
        case bar      // top-trailing bar with its own Spacer + padding (standalone screens)
        case compact  // bare pill, no outer layout (for embedding in your own HStack)
    }

    let action: SessionNavAction
    var style: Style = .bar
    var requiresConfirmation: Bool = true
    var onConfirm: () -> Void

    @State private var showConfirmation = false

    var body: some View {
        Group {
            switch style {
            case .bar:
                HStack {
                    Spacer()
                    pill
                }
                .padding(.top, 12)
                .padding(.horizontal, 20)
            case .compact:
                pill
            }
        }
        .confirmationDialog(
            action.confirmationTitle,
            isPresented: $showConfirmation,
            titleVisibility: .visible
        ) {
            Button(action.confirmButtonTitle, role: action.isDestructive ? .destructive : nil) {
                onConfirm()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(action.confirmationMessage)
        }
    }

    private var pill: some View {
        Button {
            if requiresConfirmation {
                showConfirmation = true
            } else {
                onConfirm()
            }
        } label: {
            Label(action.title, systemImage: action.icon)
                .font(.size13Semibold)
                .labelStyle(.titleAndIcon)
                .foregroundStyle(action.tint)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(action.tint.opacity(0.12)))
                .overlay(Capsule().strokeBorder(action.tint.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(action.title)
    }
}

// MARK: - Status Screens

/// "Submitting your answer... Preparing next question" — matches the screenshot.
struct SubmittingAnswerView: View {
    var onEndTapped: (() -> Void)

    var body: some View {
        VStack {
            SessionNavButton(action: .endSession, onConfirm: onEndTapped)

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
    var onEndTapped: (() -> Void)

    var body: some View {
        VStack {
            SessionNavButton(action: .endSession, onConfirm: onEndTapped)

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

    var body: some View {
        VStack {
            SessionNavButton(action: .endSession, onConfirm: onEndTapped)

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
        .background(Color.background.ignoresSafeArea())
    }
}

struct SessionCompletedView: View {
    let feedback: InterviewFeedback
    let sessionID: Int
    let presenceScore: InterviewPresenceScore

    @EnvironmentObject private var homeCoordinator: AppCoordinator<HomeRoute>
    @State private var showingPresenceSheet = false
    @StateObject var vm: PracticeSessionViewModel

    var body: some View {
        VStack(spacing: 20) {
            SessionNavButton(action: .home, requiresConfirmation: false) {
                homeCoordinator.popToRoot()
            }

            Spacer()
            WaitingStateView(
                icon: "checkmark",
                tint: .successColour,
                state: .success,
                title: "Interview Complete",
                subtitle: "Overall score: \(String(format: "%.1f", feedback.overallScore))/10"
            )

            CustomButton(buttonTitle: "For More Details") {
                homeCoordinator.push(.sessionFeedback(feedback: feedback, sessionId: sessionID))
            }

            if vm.interviewType.interviewConfiguration.mode == .video {
                CustomButton(showArrow: false, buttonTitle: "Body Language Analysis") {
                    showingPresenceSheet = true
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkBackGround.ignoresSafeArea())
        .sheet(isPresented: $showingPresenceSheet) {
                VisualAnalysisReportView(score: presenceScore)
        }
    }
}

//struct SessionCompletedView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionCompletedView(
//            feedback: .empty,
//            sessionID: 4,
//            presenceScore: InterviewPresenceScore.empty
//        )
//        .environmentObject(AppCoordinator<HomeRoute>())
//    }
//}
