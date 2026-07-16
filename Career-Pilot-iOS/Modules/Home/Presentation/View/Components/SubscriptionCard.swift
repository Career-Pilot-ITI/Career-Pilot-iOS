//
//  SubscriptionCard.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import SwiftUI

struct SubscriptionCard: View {
    var usedSessions: Double
    var totalSessions: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("FREE TRIAL")
                    .font(.caption)
                    .fontWeight(.bold)
                    .opacity(0.9)
                
                Text("\(Int(totalSessions - usedSessions)) free session remaining")
                    .font(.headline)
                
                ProgressView(value: usedSessions, total: totalSessions)
                    .tint(.white)
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                
                Text("\(Int(usedSessions)) of \(Int(totalSessions)) free sessions used")
                    .font(.caption2)
                    .opacity(0.8)
            }
            
            Spacer()
            
            Button(action: {
                // Handle upgrade logic
            }) {
                Text("Upgrade")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.primary)
        .foregroundColor(.white)
        .cornerRadius(16)
    }
}
#Preview {
    SubscriptionCard(usedSessions: 1.0, totalSessions: 3.0)
}
