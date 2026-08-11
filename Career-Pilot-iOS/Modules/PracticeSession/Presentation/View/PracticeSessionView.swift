//
//  PracticeSessionView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

struct PracticeSessionView: View {
    @StateObject var vm: PracticeSessionViewModel
    @EnvironmentObject var homeCoordinator: AppCoordinator<HomeRoute>
    
    var trackId: Int
    var interviewType: InterviewType
    
    var body: some View {
        Group {
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
                SessionCompletedView(feedback: vm.feedback, sessionID: Int(vm.session?.id ?? "0") ?? 0)
                
            case .error(let error):
                SessionErrorView(errorMessage: error.localizedDescription,
                                 onRetry: {
                    Task{
                        await vm.onError(error: error)
                    }
                },
                                 onEndTapped: {
                    homeCoordinator.popToRoot()
                })

            }
        }
        .task {
            await vm.start(trackId: trackId, interviewType: interviewType)
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
    }
}

struct PracticeSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeSessionView(vm: DIContainer.shared.container.resolve(PracticeSessionViewModel.self)!,
                            trackId: 5,
                            interviewType: .classic
        )
    }
}
