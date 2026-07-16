//
//  ProgressCard.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import SwiftUI
import SwiftUI

struct ProgressCard: View {
    let score: Int
    let progressLabel: String
    let scoreChange: String
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(score)").font(.title2).bold()
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text("OVERALL SCORE").font(.caption2).foregroundColor(.secondary)
                Text(progressLabel).font(.headline)
                Text(scoreChange).font(.caption).foregroundColor(.green)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

#Preview {
    ProgressCard(score: 78, progressLabel: "Good Progress", scoreChange: "▲ +6 from last week")
        .padding()
        .background(Color.gray.opacity(0.1))
}
