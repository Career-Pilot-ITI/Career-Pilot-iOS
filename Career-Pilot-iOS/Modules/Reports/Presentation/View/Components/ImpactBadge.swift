//
//  ImpactBadge .swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct ImpactBadge: View {
    let level: String
    var body: some View {
        Text(level)
            .font(Font.size12Bold)
            .foregroundStyle(Color.activeColour)
            .padding(.horizontal,8)
            .padding(.vertical,2)
            .background {
                Capsule()
                    .fill(Color.activeColour)
                    .opacity(0.12)
            }
    }
}

//#Preview {
//    ImpactBadge(level: "High impact")
//}
