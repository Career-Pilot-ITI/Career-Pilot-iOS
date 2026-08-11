//
//  JobHeaderCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.

import SwiftUI

struct JobHeaderCard: View {
    let initial: String
    let title: String
    let companyName: String
    let location: String
    let workMode: String
    var onOpenLink: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.accentOrange)
                .frame(width: 42, height: 42)
                .overlay(
                    Text(initial)
                        .font(Font.size18Bold)
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.size14Bold)
                    .foregroundColor(Color.textPrimary)
                Text("\(companyName) · \(location) · \(workMode)")
                    .font(Font.size13Regular)
                    .foregroundColor(Color.textSecondary)
            }

            Spacer()

            Button(action: {
                onOpenLink?()
            }) {
                Image(systemName: "arrow.up.right.square")
                    .foregroundColor(Color.gray600)
                    .font(.system(size: 16))
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16))
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        
    }
}

#Preview {
    JobHeaderCard(initial: "G", title: "Senior Frontend Engineer", companyName: "Google", location: "Cairo, EG", workMode: "Hybrid")
        .padding()
}
