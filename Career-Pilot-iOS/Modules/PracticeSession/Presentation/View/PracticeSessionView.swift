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
                LoadingView{
                    homeCoordinator.popToRoot()
                }
                
            case .aiTurn:
                AITurnView(vm: vm)
                
            case .waitingForAnswer:
                WaitingForAnswerView(vm: vm) 
                
            case .recording(let silenceWarning):
                RecordingView(vm: vm, silenceWarning: silenceWarning)
                
            case .submittingAnswer:
                SubmittingAnswerView{
                    homeCoordinator.popToRoot()
                }
                  
            case .reconnecting:
                ReconnectingView{
                    homeCoordinator.popToRoot()
                }
                
            case .completed:
                SessionCompletedView(feedback: vm.feedback, sessionID: Int(vm.session?.id ?? "0") ?? 0, presenceScore: vm.presenceScore, vm: vm )
                
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
        .onAppear {
            vm.attach(coordinator: homeCoordinator)
        }
        .task {
            await vm.onStart(trackId: trackId, interviewType: interviewType)
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
