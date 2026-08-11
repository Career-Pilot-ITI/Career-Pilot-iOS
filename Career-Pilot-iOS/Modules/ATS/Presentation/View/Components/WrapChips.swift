//
//  WrapChips.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 11/08/2026.
//

import SwiftUI

struct WrapChips: View {
    let items: [String]
    let color: Color

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(color == .orange ? .orange : .green)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(color.opacity(0.15))
                    )
            }
        }
    }
}


//#Preview {
//    WrapChips()
//}
