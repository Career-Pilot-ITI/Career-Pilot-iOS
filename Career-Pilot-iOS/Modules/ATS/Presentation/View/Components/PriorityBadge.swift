//
//  PriorityBadge.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//

import SwiftUI

struct PriorityBadge: View {
    let priority: Priority
    /// Override the displayed text, e.g. "High impact" instead of "High".
    var customText: String? = nil
 
    private var textColor: Color {
        switch priority {
        case .high: return Color.priorityHigh
        case .medium: return Color.priorityMedium
        case .low: return Color.priorityLow
        }
    }
 
    private var backgroundColor: Color {
        switch priority {
        case .high: return Color.priorityHighBackground
        case .medium: return Color.priorityMediumBackground
        case .low: return Color.priorityLowBackground
        }
    }
 
    var body: some View {
        Text(customText ?? priority.rawValue)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(textColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}
 
//#Preview {
//    HStack {
//        PriorityBadge(priority: .high)
//        PriorityBadge(priority: .medium, customText: "Medium impact")
//        PriorityBadge(priority: .low , customText: "low")
//    }
//    .padding()
//}
// 
