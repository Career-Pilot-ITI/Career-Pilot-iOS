//
//  StatusBadge.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//

import SwiftUI

struct StatusBadge: View {
    let badge: String
    let color: Color
    let padding: CGFloat
    let frame: (CGFloat, CGFloat)

    init(
        badge: String,
        color: Color,
        padding: CGFloat = 10,
        frame: (CGFloat, CGFloat) = (40, 40)
    ) {
        self.badge = badge
        self.color = color
        self.padding = padding
        self.frame = frame
    }

    var body: some View {
        Image(systemName: badge)
            .foregroundStyle(color)
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: Radius.r12)
                    .fill(color.opacity(0.10))
            }
            .frame(
                width: frame.0,
                height: frame.1
            )
    }
}

//#Preview {
//    StatusBadge()
//}
