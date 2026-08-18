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
    let sessionId: Int
    var onTap: (() -> Void)?

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack {
                Image(systemName: "doc.text")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.activeColour)
                    .padding(.trailing, 12)

                Text("View per-question breakdown")
                    .font(Font.size16SemiBold)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.gray400)
            }
            .padding(.all, 16)
            .background {
                RoundedRectangle(cornerRadius: Radius.r16)
                    .fill(Color.gray400.opacity(0.08))
            }
        }
    }
}

