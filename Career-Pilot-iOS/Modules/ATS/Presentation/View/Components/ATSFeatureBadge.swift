//
//  ATSFeatureBadge.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//
import SwiftUI

struct ATSFeatureBadge: View {
    var body: some View {
        HStack(spacing: Spacing.s8) {
            StatusBadge(badge: "dot.scope", color: Color.primaryTeal, padding: 6, frame: (28, 28))

            Text("ATS JOB MATCH")
                .font(Font.size12Bold)
                .foregroundStyle(Color.primaryTeal)
                .tracking(0.5)
        }
    }
}

#Preview {
    ATSFeatureBadge()
        .padding()
}
