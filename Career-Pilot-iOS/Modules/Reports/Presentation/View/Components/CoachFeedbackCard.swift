//
//  CoachFeedbackCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct CoachFeedbackCard: View {
    let feedback: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            SuggestionIconView(icon: "target") 

            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text("Coach Feedback")
                    .font(Font.size14Bold)

                Text(feedback)
                    .font(Font.size13Regular)
                    .foregroundStyle(Color.gray400)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color.gray400.opacity(0.08))
        }
    }
}

//#Preview {
//    CoachFeedbackCard(feedback: "Great structure. Consider leading with impact earlier.")
//}
