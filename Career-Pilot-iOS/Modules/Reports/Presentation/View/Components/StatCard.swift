//
//  StatCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct StatCard: View {
    let value: String
    let label: String
    let valueColor: Color

    var body: some View {
        VStack(spacing: Spacing.s4) {
            Text(value)
                .font(Font.size22Bold)
                .foregroundStyle(valueColor)

            Text(label)
                .font(Font.size12Regular)
                .foregroundStyle(Color.gray400)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color.gray400.opacity(0.08))
        }
    }
}

//#Preview {
//    StatCard(value: "88", label: "score", valueColor: Color.successColour)
//}
