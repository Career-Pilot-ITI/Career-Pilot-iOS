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
                .frame(width: 24, height: 24)
                .bold()
                .padding(10)
                .frame(width: 40, height: 40)
                .background {
                    RoundedRectangle(cornerRadius: Radius.r8)
                        .fill(iconColor.opacity(0.1))
                }
                .foregroundStyle(iconColor)
               
            
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
        .background(Color.gray400.opacity(0.08))
        .cornerRadius(16)
    }
}

