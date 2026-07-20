//
//  PracticeSessionView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//
    
import SwiftUI

struct PracticeSessionView: View {
    
    @StateObject var vm: PracticeSessionViewModel

    var body: some View {
        Group {
            switch vm.screenState {
            case .loading:
                ProgressView("Starting interview…")

            case .aiTurn:
                AITurnView(vm: vm)

            case .waitingForAnswer:
                WaitingForAnswerView(vm: vm)

            case .recording(let silenceWarning):
                UserTrunView(vm: vm, silenceWarning: silenceWarning)

            case .submittingAnswer:
                SubmitingAnswerView(vm: vm)

            case .reconnecting:
                ReconnectingView()

            case .completed:
                Text("Interview complete")

            case .error(let message):
                SesstionErrorView(errorMessage: message)
            }
        }
        .task {
            await vm.start()
        }
    }
}


private struct ReconnectingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Reconnecting…")
        }
    }
}

private struct SesstionErrorView: View {
    let errorMessage: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
            Text(errorMessage)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
