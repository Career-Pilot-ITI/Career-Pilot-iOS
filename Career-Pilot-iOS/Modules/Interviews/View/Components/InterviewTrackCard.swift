//
//  InterviewTrackItem.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 09/08/2026.
//

import SwiftUI

struct InterviewTrackCard: View {
    let item: InterviewItem
    let action: () -> Void

    var body: some View {
        HStack(spacing: Spacing.s12) {
            iconView

            VStack(alignment: .leading, spacing: Spacing.s6) {
                Text(item.trackInterview.track.title)
                    .font(.size16Bold)
                    .lineLimit(1)

                HStack(spacing: Spacing.s8) {
                    Text(item.level.durationText)
                        .font(.size13Regular)
                        .foregroundColor(AppColors.secondaryText)

                    Text("•")
                        .font(.size13Regular)
                        .foregroundColor(AppColors.secondaryText)

                    pill(text: item.level.rawValue, color: item.level.levelColor)
                }

                if let tag = item.trackInterview.tag {
                    pill(text: tag, color: item.trackInterview.iconColor)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: Spacing.s8)

            chevronButton
        }
        .padding(Spacing.s16)
        .background(
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }

    // MARK: - Pieces

    private var iconView: some View {
        RoundedRectangle(cornerRadius: Radius.r12, style: .continuous)
            .fill(item.trackInterview.iconBackground)
            .frame(width: 44, height: 44)
            .overlay(
                Image(systemName: item.trackInterview.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(item.trackInterview.iconColor)
            )
    }

    private func pill(text: String, color: Color) -> some View {
        Text(text)
            .font(.size12Medium)
            .foregroundColor(color)
            .padding(.horizontal, Spacing.s8)
            .padding(.vertical, 3)
            .background(Capsule().fill(color.opacity(0.15)))
    }

    private var chevronButton: some View {
        RoundedRectangle(cornerRadius: Radius.r12, style: .continuous)
            .fill(Color.primary)
            .frame(width: 40, height: 40)
            .overlay(
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            )
    }
}
