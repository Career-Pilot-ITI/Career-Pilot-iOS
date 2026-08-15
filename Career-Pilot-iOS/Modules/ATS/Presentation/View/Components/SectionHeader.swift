//
//  SectionHeader.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.

import SwiftUI

struct SectionHeader: View {
    let title: String
    var trailingText: String? = nil
    var trailingColor: Color = Color.accentTeal

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color.black)
            Spacer()
            if let trailingText {
                Text(trailingText)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(trailingColor)
            }
        }
    }
}

/// Row used inside the "Missing Requirements" list: colored dot + name + priority badge.
struct MissingRequirementRow: View {
    let keyword: RequirementKeyword

    private var dotColor: Color {
        switch keyword.priority {
        case .high: return Color.priorityHigh
        case .medium: return Color.priorityMedium
        case .low: return Color.priorityLow
        }
    }

    var body: some View {
        HStack {
            Circle()
                .fill(dotColor)
                .frame(width: 7, height: 7)
            Text(keyword.name)
                .font(.system(size: 15))
                .foregroundColor(Color.black)
            Spacer()
            PriorityBadge(priority: keyword.priority)
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    VStack(spacing: 0) {
        SectionHeader(title: "Missing Requirements", trailingText: "4 priority keywords")
        Divider().background(Color.separator)
        MissingRequirementRow(keyword: RequirementKeyword(name: "Kubernetes", priority: .high))
        Divider().background(Color.separator)
        MissingRequirementRow(keyword: RequirementKeyword(name: "GraphQL", priority: .medium))
    }
    .padding()
}
