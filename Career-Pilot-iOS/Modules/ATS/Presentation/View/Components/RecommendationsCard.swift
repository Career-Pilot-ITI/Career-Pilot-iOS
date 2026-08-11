//
//  RecommendationsCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import SwiftUI

struct RecommendationsCard: View {
    let recommendations: [Recommendation]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recommendations")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                ForEach(recommendations) { rec in
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.matchGreen.opacity(0.12))
                                .frame(width: 24, height: 24)
                            Text("\(rec.index)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.matchGreen)
                        }

                        Text(rec.text)
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
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }
}

#Preview {
    RecommendationsCard(recommendations: JobMatchData.sample.recommendations)
        .padding()
        .background(Color.screenBackground)
}
