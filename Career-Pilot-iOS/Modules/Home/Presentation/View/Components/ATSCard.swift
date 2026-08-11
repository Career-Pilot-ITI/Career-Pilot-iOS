//
//  ATSCard.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 09/08/2026.
//

import SwiftUI

struct ATSCard: View {

    let iconName: String
    let title: String
    let badgeText: String?
    let subtitle: String
    let accentColor: Color          
    let action: () -> Void

    init(
        iconName: String,
        title: String,
        badgeText: String? = nil,
        subtitle: String,
        accentColor: Color = .primaryTeal,
        action: @escaping () -> Void = {}
    ) {
        self.iconName = iconName
        self.title = title
        self.badgeText = badgeText
        self.subtitle = subtitle
        self.accentColor = accentColor
        self.action = action
    }


    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.s12) {
                iconView
                textStack
                Spacer(minLength: Spacing.s8)
                chevron
            }
            .padding(Spacing.s16)
            .background(background)
            .overlay(border)
        }
        .buttonStyle(.plain)
    }


    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radius.r12, style: .continuous)
                .fill(accentColor.opacity(0.15))
                .frame(width: 48, height: 48)

            Image(systemName: iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(accentColor)
        }
    }

    private var textStack: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            HStack(spacing: Spacing.s8) {
                Text(title)
                    .font(.size16Bold)

                if let badgeText {
                    badgePill(badgeText)
                }
            }

            Text(subtitle)
                .font(.size14Regular)
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func badgePill(_ text: String) -> some View {
        Text(text)
            .font(.size11Bold)
            .foregroundColor(accentColor)
            .padding(.horizontal, Spacing.s8)
            .padding(.vertical, 3)
            .background(
                Capsule().fill(accentColor.opacity(0.15))
            )
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(accentColor)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
            .fill(accentColor.opacity(0.08))
    }

    private var border: some View {
        RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
            .stroke(accentColor.opacity(0.25), lineWidth: 1)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.s16) {
        ATSCard(
            iconName: "scope",
            title: "ATS Job Match",
            badgeText: "NEW",
            subtitle: "Paste a job link · See how your CV scores",
            accentColor: .primaryTeal,
            action: { print("Tapped ATS Job Match") }
        )

        ATSCard(
            iconName: "doc.text.magnifyingglass",
            title: "Resume Review",
            subtitle: "Get instant AI feedback on your CV",
            accentColor: .activeColour,
            action: { print("Tapped Resume Review") }
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}


