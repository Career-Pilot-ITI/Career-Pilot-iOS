//
//  WaitingStateComponents.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import SwiftUI

struct SuccessPaymentScreen: View {
    var body: some View {
        WaitingStateView(
            icon: "checkmark.circle.fill",
            tint: .green,
            state: .success,
            title: "Payment Successful",
            subtitle: "Your payment has been processed successfully."
        )
    }
}

struct SuccessOTPScreen: View {
    var body: some View {
        WaitingStateView(
            icon: "checkmark.circle.fill",
            tint: .green,
            state: .success,
            title: "You're in!",
            subtitle: "Setting up your coaching session…"
        )
    }
}

struct CallingWaitingScreen: View {
    let phoneNumber: String
    var body: some View {
        WaitingStateView(
            icon: "phone.fill",
            state: .loading,
            title: "Sending your code…",
            subtitle: "We're sending a 6-digit OTP to",
            phoneNumber: phoneNumber
        )
    }
}

struct UploadingWaitingScreen: View {
    var body: some View {
        WaitingStateView(
            icon: "arrow.up.circle.fill",
            tint: .blue,
            state: .loading,
            title: "Uploading files",
            subtitle: "This might take a moment"
        )
    }
}

struct ListeningWaitingScreen: View {
    var body: some View {
        WaitingStateView(
            icon: "mic.fill",
            state: .listening,
            title: "Listening...",
            subtitle: "Go ahead, we're picking up your voice"
        )
    }
}

struct RecordingWaitingScreen: View {
    var body: some View {
        WaitingStateView(
            icon: "mic.fill",
            state: .recording,
            title: "Recording",
            subtitle: "Tap stop when you're done"
        )
    }
}

struct FailureWaitingScreen: View {
    var body: some View {
        WaitingStateView(
            icon: "exclamationmark.triangle.fill",
            state: .failure,
            title: "Something went wrong",
            subtitle: "We couldn't complete your request",
            actionTitle: "Try Again",
            action: {}
        )
    }
}

#Preview("Payment") {
    SuccessPaymentScreen()
}

#Preview("Calling") {
    CallingWaitingScreen(phoneNumber: "+20 101 234 5678")
}

#Preview("Uploading") {
    UploadingWaitingScreen()
}

#Preview("Listening") {
    ListeningWaitingScreen()
}

#Preview("Recording") {
    RecordingWaitingScreen()
}

#Preview("Failure") {
    FailureWaitingScreen()
}
