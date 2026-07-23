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
                    .foregroundStyle(Color.primaryNavy)

                Text(feedback)
                    .font(Font.size13Regular)
                    .foregroundStyle(Color.gray600)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(.white)
        }
    }
}

//#Preview {
//    CoachFeedbackCard(feedback: "Great structure. Consider leading with impact earlier.")
//}
