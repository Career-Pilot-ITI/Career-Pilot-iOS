//
//  TrackInterviewCard.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//

import SwiftUI

struct CareerCardView: View {
    let iconName: String
    let title: String
    let tagText: String
    let durationText: String
    let accentColor: Color
    let onStartInterview: () -> Void
    let onStartQuiz: () -> Void
    
    @State private var showEntryOptions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: Radius.r16)
                    .fill(accentColor.opacity(0.12))
                
                Image(systemName: iconName)
                    .font(.size18Bold)
                    .foregroundColor(accentColor)
            }
            .frame(width: 56, height: 56)
            
            // Title
            Text(title)
                .font(.size20Bold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            // Tag Pill
            Text(tagText)
                .font(.size14Semibold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(accentColor)
                .padding(.horizontal, Spacing.s4)
                .padding(.vertical, Spacing.s6)
                .background(
                    Capsule()
                        .fill(accentColor.opacity(0.12))
                )
            
            HStack {
                Text(durationText)
                    .font(.size16Medium)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: { showEntryOptions = true }) {
                    Image(systemName: "chevron.right")
                        .font(.size16Bold)
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(accentColor)
                        .cornerRadius(Radius.r14)
                }
            }
        }
        .padding(Spacing.s24)
        .frame(width: 200, height: 250)
        .background(Color.gray400.opacity(0.08))
        .cornerRadius(Radius.r24)
        .shadow(color: Color.black.opacity(0.05), radius: Radius.r16, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.r24)
                .stroke(Color(.systemGray6), lineWidth: 1)
        )
        .confirmationDialog(
            "Start \(title)",
            isPresented: $showEntryOptions,
            titleVisibility: .visible
        ) {
            Button("Interview") { onStartInterview() }
            Button("Quiz Path") { onStartQuiz() }
            Button("Cancel", role: .cancel) {}
        }
    }
}
