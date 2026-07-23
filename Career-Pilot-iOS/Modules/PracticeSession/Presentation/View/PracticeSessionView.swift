//
//  PracticeSessionView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

struct PracticeSessionView: View {
    @StateObject var vm: PracticeSessionViewModel = PracticeSessionViewModelFactory.makeStub(realRepo: false)

    var body: some View {
        Group {
            NavigationStack{
                switch vm.screenState {
                case .loading:
                    LoadingView()

                case .aiTurn:
                    AITurnView(vm: vm)

                case .waitingForAnswer:
                    WaitingForAnswerView(vm: vm) // Probelm with nav to this state

                case .recording(let silenceWarning):
                    RecordingView(vm: vm, silenceWarning: silenceWarning)

                case .submittingAnswer:
                    SubmittingAnswerView()

                case .reconnecting:
                    ReconnectingView()

                case .completed:
                    SessionCompletedView(feedback: vm.feedback)

                case .error(let error):
                    SessionErrorView(errorMessage: error.localizedDescription){
                        Task{
                            await vm.onError(error: error)
                        }
                    }
                }
            }
        }
        .task {
            await vm.start()
        }
    }
}

struct PracticeSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeSessionView(vm: PracticeSessionViewModelFactory.makeStub(realRepo: false))
    }
}
