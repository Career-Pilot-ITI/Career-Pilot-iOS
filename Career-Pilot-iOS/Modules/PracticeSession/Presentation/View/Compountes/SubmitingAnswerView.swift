//
//  SubmitingAnswerView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import SwiftUI

struct SubmitingAnswerView: View {
    @ObservedObject var vm: PracticeSessionViewModel

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Submitting your answer…")
            Text("Preparing next question")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

//struct SubmitingAnswerView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubmitingAnswerView()
//    }
//}
