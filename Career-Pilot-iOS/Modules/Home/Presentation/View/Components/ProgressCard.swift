//
//  ProgressCard.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//
import SwiftUI

struct ProgressCard: View {
    let info: OverallProgressInfo
    
    var body: some View {
        HStack(spacing: 20) {
            // Circular Score Progress
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: CGFloat(info.currentScore) / 100)
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text("\(info.currentScore)")
                    .font(.title2)
                    .bold()
            }
            .frame(width: 60, height: 60)
            
            // Text Details
            VStack(alignment: .leading, spacing: 4) {
                Text("OVERALL SCORE")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(info.title)
                    .font(.headline)
                
                Text(info.comparisonText)
                    .font(.caption)
                    .foregroundColor(
                        info.isPositive == true ? .green : (info.isPositive == false ? .red : .secondary)
                    )
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(16)
    }
}

#Preview {
    ProgressCard(
        info: OverallProgressInfo(
            currentScore: 88,
            scoreDifference: 6
        )
    )
    .padding()
    .background(Color.black)
}
