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
                .font(Font.size14Bold)
                .foregroundColor(Color.textPrimary)

            VStack(spacing: 12) {
                ForEach(recommendations) { rec in
                    HStack(alignment: .center, spacing: Spacing.s12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: Radius.r6)
                                .fill(.teal.opacity(0.12))
                                .frame(width: 24, height: 24)
                            Text("\(rec.index)")
                                .font(Font.size11Bold)
                                .foregroundColor(.teal)
                        }

                        Text(rec.text)
                            .font(Font.size13Regular)
                            .foregroundColor(Color.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 12)
                }
            }
        }
        .padding(.all, 16)
        .background(Color.gray400.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16))
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        
    }
}

//#Preview {
//    RecommendationsCard(recommendations: JobMatchData.sample.recommendations)
//        .padding()
//        .background(Color.screenBackground)
//}
