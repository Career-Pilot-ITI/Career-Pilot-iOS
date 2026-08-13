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
    let iconColor : Color
    let action: () -> Void

    var body: some View {
        HStack {
            Text("\(score)")
                .bold()
                .padding(10)
                .background(iconColor.opacity(0.1))
                .foregroundColor(iconColor)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(title).font(.subheadline).bold()
                Text(time).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Button(action: action) {
                Image(systemName: "chevron.right")
                    .font(.size16Bold)
                    .foregroundColor(.secondary)
                    .frame(width: 48, height: 48)
                    .cornerRadius(Radius.r14)
            }
        }
        .padding()
        .background(Color.background)
        .cornerRadius(16)
    }
}

