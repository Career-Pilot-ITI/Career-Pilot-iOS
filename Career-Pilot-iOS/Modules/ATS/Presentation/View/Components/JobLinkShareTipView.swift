//
//  JobLinkShareTipView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 08/08/2026.
//

import SwiftUI

struct JobLinkShareTipView: View {
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            Image(systemName: "sparkles")
                .foregroundStyle(Color.primaryTeal)

            (
                Text("Faster: ")
                    .fontWeight(.bold)
                + Text("In LinkedIn or any job app — tap ")
                + Text("Share → CareerPilot")
                    .fontWeight(.bold)
                + Text(". The link is captured automatically.")
            )
            .foregroundStyle(Color.primaryTeal)
            .font(Font.size12Medium)
        }
        .padding(Spacing.s16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color.primaryTeal)
                .opacity(0.05)
        }
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16)
                .stroke(Color.primaryTeal.opacity(0.3), lineWidth: 1)
        }
    }
}

#Preview {
    JobLinkShareTipView()
}
