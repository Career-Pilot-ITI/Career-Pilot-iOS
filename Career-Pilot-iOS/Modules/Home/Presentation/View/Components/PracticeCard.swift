//
//  PracticeCard.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import SwiftUI

struct PracticeCard: View {
    let category: String

    var body: some View {
        HStack {
            Image(systemName: "mic.fill")
                .foregroundColor(Color.primary)
                .padding()
                .background(Color.primary.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading) {
                Text(category).font(.caption2).opacity(0.8)
                Text("Practice Interview").font(.headline)
            }
            Spacer()
            Image(systemName: "arrow.right")
                .padding(10)
                .background(Color.primary)
                .cornerRadius(8)
        }
        .padding()
        .background(Color(red: 0.1, green: 0.15, blue: 0.3))
        .foregroundColor(.white)
        .cornerRadius(16)
    }
}

#Preview {
    PracticeCard(category: "SOFTWARE ENGINEERING")
}
