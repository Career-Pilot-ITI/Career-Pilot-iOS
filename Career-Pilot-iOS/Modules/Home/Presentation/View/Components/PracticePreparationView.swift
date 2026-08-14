//
//  PracticePreparationView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//
import Foundation
import SwiftUI

struct PracticePreparationView: View {
    let categoryText: String
    let metadataText: String
    let title: String
    let subtitle: String
    let tips: [PracticeTip]

    @Binding var selectedMode: InterviewMode
    @Binding var isMicrophoneGranted: Bool
    @Binding var isCameraGranted: Bool

    let accentColor: Color
    let onCancel: () -> Void
    let onBegin: () -> Void

    private var isReadyToBegin: Bool {
        isMicrophoneGranted && (selectedMode == .audio || isCameraGranted)
    }

    var body: some View {
        ScrollView{
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
            .padding(Spacing.s24)
            .background(Color.gray.opacity(0.08))
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

                // Title Section
                VStack(alignment: .leading, spacing: Spacing.s8) {
                    Text(title)
                        .font(.size26Semibold)

                    Text(subtitle)
                        .font(.size16Regular)
                        .foregroundColor(.secondary)
                }


                // Tips Card Container
                VStack(alignment: .leading, spacing: Spacing.s6) {
                    ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                        VStack(spacing: Spacing.s16) {
                            HStack(alignment: .top, spacing: Spacing.s8) {
                                Text(tip.stepNumber)
                                    .font(.size15Bold)
                                    .frame(width: 28, height: 28)
                                    .background(accentColor.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: Radius.r8))

                                Text(tip.text)
                                    .font(.size16Medium)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            if index < tips.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.s24)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: Radius.r24))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.r24)
                        .stroke(Color(.separator), lineWidth: 1)
                )
                .shadow(
                    color: Color.black.opacity(0.04),
                    radius: Radius.r16,
                    x: 0,
                    y: 5
                )
                
                // Mode Selection
                InterviewModeSelector(selectedMode: $selectedMode, accentColor: accentColor)

                // Microphone Access Permission Bar
                PermissionBar(
                    icon: "mic.fill",
                    title: "Microphone Access",
                    isGranted: isMicrophoneGranted,
                    accentColor: accentColor,
                    isOn: $isMicrophoneGranted
                )

                // Camera Access Permission Bar — only relevant for video interviews
                if selectedMode == .video {
                    PermissionBar(
                        icon: "video.fill",
                        title: "Camera Access",
                        isGranted: isCameraGranted,
                        accentColor: accentColor,
                        isOn: $isCameraGranted
                    )
                }

                Spacer()

                // Action CTA Button
                Button(action: onBegin) {
                    HStack(spacing: Spacing.s8) {
                        Image(systemName: selectedMode == .video ? "video.fill" : "mic.fill")
                            .font(.size16Bold)
                        Text("Begin Interview")
                            .font(.size16Bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(isReadyToBegin ? .primary : Color(.systemGray4))
                    .cornerRadius(Radius.r16)
                    .shadow(color: isReadyToBegin ? .primary.opacity(0.3) : Color.clear, radius: Radius.r12, x: 0, y: 4)
                
                Toggle("", isOn: $isMicrophoneGranted)
                    .labelsHidden()
                    .tint(accentColor)
            }
            .padding(Spacing.s16)
            .background(Color.gray.opacity(0.08))
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
                .disabled(!isReadyToBegin)
                .padding(.bottom, Spacing.s16)
            }
            .padding(.horizontal, Spacing.s24)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .animation(.easeInOut, value: selectedMode)
        }
    }
}

/// Shared row for microphone/camera access, factored out since both look identical
/// apart from icon/title/binding.
private struct PermissionBar: View {
    let icon: String
    let title: String
    let isGranted: Bool
    let accentColor: Color
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: Spacing.s16) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.r16)
                    .fill(Color.red.opacity(0.12))
                    .frame(width: 48, height: 48)

                Image(systemName: icon)
                    .foregroundColor(.red)
                    .font(.size18Bold)
            }

            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text(title)
                    .font(.size16Bold)

                Text(isGranted ? "Access Granted" : "Required to practice")
                    .font(.size14Medium)
                    .foregroundColor(isGranted ? .green : .red)
            }

            Spacer()

            Toggle("", isOn: $isOn)
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
    }
}
