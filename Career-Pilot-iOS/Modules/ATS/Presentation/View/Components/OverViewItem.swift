//
//  OverViewItem.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import SwiftUI

struct OverViewItem: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 10) {
            StatusBadge(badge: icon, color: .secondary, padding: 8, frame: (32,32))

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(Font.size11Semibold)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(Font.size13Bold)
                    .foregroundStyle(Color.textPrimary)

            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    OverViewItem(icon: "briefcase.fill", label: "Employment Type", value: "ss")
}
