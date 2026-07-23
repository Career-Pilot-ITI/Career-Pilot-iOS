//
//  UserTrunView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

struct UserTrunView: View {
    @ObservedObject var vm: PracticeSessionViewModel = PracticeSessionViewModelFactory.makeStub(realRepo: false)

    let silenceWarning: SilenceWarning?

    var body: some View {
        VStack(spacing: 24) {
            Text("Q\(vm.currentQuestionNumber)/\(vm.totalQuestions)")

            if let silenceWarning = silenceWarning {
                Text("Silence detected — moving to next question in \(silenceWarning.remainingSeconds)s")
                    .padding(8)
                    .background(Color.orange.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Image(systemName: "mic.fill")
                .font(.system(size: 60))
            Text(String(format: "%02d:%02d", Int(vm.elapsedRecordingTime) / 60, Int(vm.elapsedRecordingTime) % 60))

            Text(vm.currentQuestionText)
                .padding()

            Button {
                vm.submitAnswerManually()
            } label: {
                Label("Submit Answering", systemImage: "checkmark")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

//struct UserTrunView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserTrunView()
//    }
//}
