//
//  ImpactBadge .swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct ImpactBadge: View {
    let level: String
    var badgeColor : Color {
        switch level {
        case "High impact":
            return Color.red
        case "Medium":
            return Color.primaryYellow
        case "Low":
            return Color.successColour
        default :
            return Color.gray
        }
    }
    var body: some View {
        Text(level)
            .font(Font.size12Bold)
            .foregroundStyle(badgeColor)
            .padding(.horizontal,8)
            .padding(.vertical,2)
            .background {
                Capsule()
                    .fill(badgeColor)
                    .opacity(0.12)
            }
    }
}

//#Preview {
//    ImpactBadge(level: "High impact")
//}
