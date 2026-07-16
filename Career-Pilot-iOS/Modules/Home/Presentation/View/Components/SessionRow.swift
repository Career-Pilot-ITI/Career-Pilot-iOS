//
//  SessionRow.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import SwiftUI

struct SessionRow: View {
    let score: Int
    let title: String
    let time: String
    
    var body: some View {
        HStack {
            Text("\(score)")
                .bold()
                .padding(10)
                .background(Color.orange.opacity(0.1))
                .foregroundColor(.orange)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(title).font(.subheadline).bold()
                Text(time).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

