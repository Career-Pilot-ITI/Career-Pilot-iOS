//
//  SkillChipsView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import SwiftUI

struct SkillChip: View {
    let text: String
    let status: SkillStatus

    private var icon: String {
        switch status {
        case .matched: return "checkmark"
        case .missingRequired: return "xmark"
        case .missingPreferred: return "clock"
        }
    }

    private var foreground: Color {
        switch status {
        case .matched: return .matchGreen
        case .missingRequired: return .matchRed
        case .missingPreferred: return .matchAmber
        }
    }

    private var background: Color {
        switch status {
        case .matched: return .greenChipBg
        case .missingRequired: return .redChipBg
        case .missingPreferred: return .amberChipBg
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .bold))
            Text(text)
                .font(.system(size: 13, weight: .medium))
        }
        .foregroundColor(foreground)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(background)
        .clipShape(Capsule())
    }
}

struct SkillChipsCard: View {
    let title: String
    let badgeText: String?
    let badgeColor: Color
    let items: [String]
    let status: SkillStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(Font.size14Bold)
                Spacer()
                if let badgeText {
                    Text(badgeText)
                        .font(Font.size11Semibold)
                        .foregroundColor(badgeColor)
                }
            }

            if items.isEmpty {
                Text("None")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        SkillChip(text: item, status: status)
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16))
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        
    }
}
//
//#Preview {
//    VStack(spacing: 16) {
//        SkillChipsCard(
//            title: "Matched Requirements",
//            badgeText: "8 of 12 keywords",
//            badgeColor: .matchGreen,
//            items: ["React", "TypeScript", "Node.js", "System Design", "AWS", "REST APIs", "Leadership", "Agile"],
//            status: .matched
//        )
//        SkillChipsCard(
//            title: "Missing Required Skills",
//            badgeText: "8 of 12 keywords",
//            badgeColor: .matchRed,
//            items: ["Agile", "Agile", "Agile", "Agile", "Agile", "Agile"],
//            status: .missingRequired
//        )
//        SkillChipsCard(
//            title: "Missing Preferred Skills",
//            badgeText: "8 of 12 keywords",
//            badgeColor: .matchAmber,
//            items: ["Terraform"],
//            status: .missingPreferred
//        )
//    }
//    .padding()
//    .background(Color.screenBackground)
//}
