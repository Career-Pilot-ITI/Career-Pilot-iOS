//
//  RadarMetricsLegend.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct RadarMetricsLegend: View {
    let metrics: [RadarMetric]

    private let columns = [
        GridItem(.flexible(), spacing: Spacing.s12, alignment: .leading),
        GridItem(.flexible(), spacing: Spacing.s12, alignment: .leading)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: Spacing.s12) {
            ForEach(metrics) { metric in
                RadarMetricChip(metric: metric)
            }
        }
    }
}

//#Preview {
//    RadarMetricsLegend(metrics: [
//        RadarMetric(label: "Clarity", value: 78, color: .orange),
//        RadarMetric(label: "Confidence", value: 85, color: .green),
//        RadarMetric(label: "Pacing", value: 72, color: .orange),
//        RadarMetric(label: "Filler Words", value: 65, color: .orange),
//        RadarMetric(label: "Content", value: 90, color: .green)
//    ])
//}
