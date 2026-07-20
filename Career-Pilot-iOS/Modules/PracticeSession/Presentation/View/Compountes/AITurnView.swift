//
//  AITurnView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI


struct AITurnView: View {
    @ObservedObject var vm: PracticeSessionViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Q\(vm.currentQuestionNumber)/\(vm.totalQuestions)")
            Image(systemName: "headphones")
                .font(.system(size: 60))
            Text("AI COACH SPEAKING")
                .font(.caption)
            Text(vm.currentQuestionText)
                .padding()
        }
    }
}


//struct AITurnView_Previews: PreviewProvider {
//    static var previews: some View {
//        AITurnView()
//    }
//}
