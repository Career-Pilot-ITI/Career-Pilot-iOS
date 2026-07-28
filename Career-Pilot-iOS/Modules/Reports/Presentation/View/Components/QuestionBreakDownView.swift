//
//  QuestionBreakDownView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

// QuestionBreakDownView.swift
import SwiftUI

struct QuestionBreakDownView: View {
    @EnvironmentObject var coordinator: AppCoordinator<ReportsRoute>
    let sessionId: Int

    var body: some View {
        Button {
            coordinator.push(.questionBreakdown(sessionId: sessionId))
        } label: {
            HStack {
                Image(systemName: "doc.text")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.activeColour)
                    .padding(.trailing, 12)

                Text("View per-question breakdown")
                    .font(Font.size16SemiBold)
                    .foregroundStyle(Color.primaryNavy)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.gray400)
            }
            .padding(.all, 16)
            .background {
                RoundedRectangle(cornerRadius: Radius.r16)
                    .fill(.white)
            }
        }
    }
}

