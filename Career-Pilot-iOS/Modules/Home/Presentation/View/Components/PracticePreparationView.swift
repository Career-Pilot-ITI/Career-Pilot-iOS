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
                .foregroundColor(Color(red: 0.2, green: 0.24, blue: 0.3))
            }
            .padding(.top, Spacing.s8)
            
            HStack(spacing: Spacing.s12) {
                Text(categoryText)
                    .font(.size14Semibold)
                    .foregroundColor(Color(red: 0.2, green: 0.24, blue: 0.3))
                    .padding(.horizontal, Spacing.s12)
                    .padding(.vertical, Spacing.s8)
                    .background(Color(.systemGray6))
                    .cornerRadius(Radius.r8)
                
                Text(metadataText)
                    .font(.size14Semibold)
                    .foregroundColor(accentColor)
                    .padding(.horizontal, Spacing.s12)
                    .padding(.vertical, Spacing.s8)
                    .background(accentColor.opacity(0.12))
                    .cornerRadius(Radius.r8)
            }
            
            VStack(alignment: .leading, spacing: Spacing.s8) {
                Text(title)
                    .font(.size26Semibold)
                    .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.2))
                
                Text(subtitle)
                    .font(.size16Regular)
                    .foregroundColor(.secondary)
            }
            
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
                            .foregroundColor(Color(red: 0.15, green: 0.18, blue: 0.25))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    
                    if index < tips.count - 1 {
                        Divider()
                            .background(Color(.systemGray6))
                    }
                }
            }
            .padding(Spacing.s24)
            .background(Color.white)
            .cornerRadius(Radius.r24)
            .shadow(color: Color.black.opacity(0.03), radius: Radius.r16, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.r24)
                    .stroke(Color(.systemGray6), lineWidth: 1)
            )
            
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
                        .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.2))
                    
                    Text("Required to practice")
                        .font(.size14Medium)
                        .foregroundColor(.red.opacity(0.8))
                }
                
                Spacer()
                
                Toggle("", isOn: $isMicrophoneGranted)
                    .labelsHidden()
                    .tint(accentColor)
            }
            .padding(Spacing.s16)
            .background(Color.white)
            .cornerRadius(Radius.r20)
            .shadow(color: Color.black.opacity(0.03), radius: Radius.r16, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.r20)
                    .stroke(Color(.systemGray6), lineWidth: 1)
            )
            
            Spacer()
            
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
                .background(isMicrophoneGranted ? accentColor : Color(.systemGray4))
                .cornerRadius(Radius.r16)
                .shadow(color: isMicrophoneGranted ? accentColor.opacity(0.3) : Color.clear, radius: Radius.r12, x: 0, y: 4)
            }
            .disabled(!isMicrophoneGranted) 
            .padding(.bottom, Spacing.s16)
        }
        .padding(.horizontal, Spacing.s24)
        .background(Color(.systemGroupedBackground))
    }
}
