//
//  WaitingForAnswerView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

struct WaitingForAnswerView: View {
    @ObservedObject var vm: PracticeSessionViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Q\(vm.currentQuestionNumber)/\(vm.totalQuestions)")
            Text("YOUR TURN")
                .font(.caption)
            Text(vm.currentQuestionText)
                .padding()
            Button {
                vm.startAnswering()
            } label: {
                Label("Start Answering", systemImage: "mic.fill")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}


//struct WaitingForAnswerView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingForAnswerView()
//    }
//}
