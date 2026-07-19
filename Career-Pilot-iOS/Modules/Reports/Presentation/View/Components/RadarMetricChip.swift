//
//  RadarMetricChip.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct RadarMetricChip: View {
    let metric: RadarMetric
    var body: some View {
        HStack(spacing: Spacing.s6) {
            Circle()
                .fill(metric.color)
                .frame(width: 7, height: 7)
            Text("\(metric.label) \(Int(metric.value))")
                .font(Font.size12Bold)
                .foregroundColor(metric.color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background {
            Capsule()
                .fill(metric.color)
                .opacity(0.08)
        }
    }
}

#Preview {
    RadarMetricChip(metric:     RadarMetric(label: "Clarity", value: 78, color: .orange))
}
