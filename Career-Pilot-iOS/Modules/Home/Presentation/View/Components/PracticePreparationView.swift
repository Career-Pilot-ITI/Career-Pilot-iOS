//
//  PracticePreparationView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//

import SwiftUI

struct PracticePreparationView: View {
    let categoryText: String
    let metadataText: String
    let title: String
    let subtitle: String
    let tips: [PracticeTip]
    
    @Binding var isMicrophoneGranted: Bool
    
    let accentColor: Color
    let onCancel: () -> Void
    let onBegin: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s24) {
            
            Button(action: onCancel) {
                HStack(spacing: Spacing.s8) {
                    Image(systemName: "xmark")
                        .font(.size16Bold)
                    Text("Cancel")
                        .font(.size16Medium)
                }
                .foregroundColor(.secondary)
            }
            .padding(.top, Spacing.s8)
            
            // Header Tags
            HStack(spacing: Spacing.s12) {
                Text(categoryText)
                    .font(.size14Semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, Spacing.s12)
                    .padding(.vertical, Spacing.s8)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .cornerRadius(Radius.r8)
                
                Text(metadataText)
                    .font(.size14Semibold)
                    .foregroundColor(accentColor)
                    .padding(.horizontal, Spacing.s12)
                    .padding(.vertical, Spacing.s8)
                    .background(accentColor.opacity(0.12))
                    .cornerRadius(Radius.r8)
            }
            
            // Title Section
            VStack(alignment: .leading, spacing: Spacing.s8) {
                Text(title)
                    .font(.size26Semibold)
                
                Text(subtitle)
                    .font(.size16Regular)
                    .foregroundColor(.secondary)
            }
            
            // Tips Card Container
            VStack(alignment: .leading, spacing: Spacing.s16) {
                ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                    HStack(alignment: .top, spacing: Spacing.s16) {
                        Text(tip.stepNumber)
                            .font(.size14Bold)
                            .foregroundColor(accentColor)
                            .frame(width: 28, height: 28)
                            .background(accentColor.opacity(0.15))
                            .cornerRadius(Radius.r8)
                        
                        Text(tip.text)
                            .font(.size16Medium)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    
                    if index < tips.count - 1 {
                        Divider()
                            .background(Color(.separator))
                    }
                }
            }
            .padding(Spacing.s24)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(Radius.r24)
            .shadow(color: Color.black.opacity(0.04), radius: Radius.r16, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.r24)
                    .stroke(Color(.separator), lineWidth: 1)
            )
            
            // Microphone Access Permission Bar
            HStack(spacing: Spacing.s16) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.r16)
                        .fill(Color.red.opacity(0.12))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "mic.fill")
                        .foregroundColor(.red)
                        .font(.size18Bold)
                }
                
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text("Microphone Access")
                        .font(.size16Bold)
                    
                    Text(isMicrophoneGranted ? "Access Granted" : "Required to practice")
                        .font(.size14Medium)
                        .foregroundColor(isMicrophoneGranted ? .green : .red)
                }
                
                Spacer()
                
                Toggle("", isOn: $isMicrophoneGranted)
                    .labelsHidden()
                    .tint(accentColor)
            }
            .padding(Spacing.s16)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(Radius.r20)
            .shadow(color: Color.black.opacity(0.04), radius: Radius.r16, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.r20)
                    .stroke(Color(.separator), lineWidth: 1)
            )
            
            Spacer()
            
            // Action CTA Button
            Button(action: onBegin) {
                HStack(spacing: Spacing.s8) {
                    Image(systemName: "mic.fill")
                        .font(.size16Bold)
                    Text("Begin Interview")
                        .font(.size16Bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isMicrophoneGranted ? .primary : Color(.systemGray4))
                .cornerRadius(Radius.r16)
                .shadow(color: isMicrophoneGranted ? .primary.opacity(0.3) : Color.clear, radius: Radius.r12, x: 0, y: 4)
            }
            .disabled(!isMicrophoneGranted)
            .padding(.bottom, Spacing.s16)
        }
        .padding(.horizontal, Spacing.s24)
        .background(Color(.background).ignoresSafeArea())
    }
}
