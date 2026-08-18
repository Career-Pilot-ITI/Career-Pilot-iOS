//
//  NextStepsCardView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import SwiftUI

struct NextStepsCard: View {
    let steps: [Recommendation]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Next Steps")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
            }

            VStack(spacing: 12) {
                ForEach(steps) { step in
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.matchGreen.opacity(0.12))
                                .frame(width: 24, height: 24)
                            Text("\(step.index)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.matchGreen)
                        }

                        Text(step.text)
                            .font(.system(size: 14))
                            .foregroundColor(.primary.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer(minLength: 0)
                    }
                    .padding(12)
                    .background(Color.screenBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
        }
        .padding(16)
        .background(Color.gray400.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }
}

//#Preview {
//    NextStepsCard(steps: CoverLetterData.sample.nextSteps)
//        .padding()
//        .background(Color.screenBackground)
//}
