//
//  InterviewModeSelector.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.

import SwiftUI

struct InterviewModeSelector: View {
    @Binding var selectedMode: InterviewMode
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Interview Type")
                .font(.size16Bold)

            HStack(spacing: Spacing.s12) {
                ModeCard(
                    icon: "mic.fill",
                    title: "Audio Only",
                    subtitle: "Voice responses",
                    isSelected: selectedMode == .audio,
                    accentColor: accentColor
                ) {
                    selectedMode = .audio
                }

                ModeCard(
                    icon: "video.fill",
                    title: "Video",
                    subtitle: "Camera + voice",
                    isSelected: selectedMode == .video,
                    accentColor: accentColor
                ) {
                    selectedMode = .video
                }
            }
        }
    }
}

private struct ModeCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let accentColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.s12) {
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.r12)
                        .fill(accentColor.opacity(isSelected ? 0.18 : 0.10))
                        .frame(width: 40, height: 40)

                    Image(systemName: icon)
                        .font(.size16Bold)
                        .foregroundColor(isSelected ? accentColor : .secondary)
                }

                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(title)
                        .font(Font.size15Bold)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.size13Regular)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.s16)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(Radius.r16)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.r16)
                    .stroke(isSelected ? accentColor : Color(.separator), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
//struct InterviewModeSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        InterviewModeSelector(selectedMode: .audio, accentColor: Color.activeColour)
//    }
//}
