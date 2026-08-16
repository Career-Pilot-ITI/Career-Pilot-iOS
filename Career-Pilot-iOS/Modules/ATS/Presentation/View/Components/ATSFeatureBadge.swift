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
            StatusBadge(
                badge: "target",
                color: Color.primaryTeal,
                padding: 7,
                frame: (30, 30)
            )

            Text("ATS JOB MATCH")
                .font(Font.size13Bold)
                .tracking(0.5)
        }
    }
}

//#Preview {
//    ATSFeatureBadge()
//        .padding()
//}
