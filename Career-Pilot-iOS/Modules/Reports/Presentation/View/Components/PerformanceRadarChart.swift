//
//  PerformanceRadarChart.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct RadarMetric: Identifiable {
    let id = UUID()
    let label: String
    let value: Double // 0...100
    let color: Color
}

struct PerformanceRadarChart: View {
    let metrics: [RadarMetric]
    var body: some View {
        GeometryReader { geo in
            let labelInset: CGFloat = 44
            let chartSize = min(geo.size.width, geo.size.height) - (labelInset * 2)
            let center = geo.size.width / 2

            ZStack {
                RadarGridShape(sides: metrics.count, rings: 4)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    .frame(width: chartSize, height: chartSize)

                RadarShape(values: metrics.map { $0.value / 100 })
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: chartSize, height: chartSize)

                RadarShape(values: metrics.map { $0.value / 100 })
                    .stroke(Color.orange, lineWidth: 2)
                    .frame(width: chartSize, height: chartSize)

                ForEach(Array(metrics.enumerated()), id: \.element.id) { index, metric in
                    let angle = (2 * Double.pi / Double(metrics.count)) * Double(index) - .pi / 2
                    let labelRadius = (chartSize / 2) + 24

                    Text(metric.label)
                        .font(Font.size11Bold)
                        .foregroundStyle(Color.gray600)
                        .fixedSize()
                        .position(
                            x: center + CGFloat(cos(angle)) * labelRadius,
                            y: center + CGFloat(sin(angle)) * labelRadius
                        )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}


#Preview {
    PerformanceRadarChart(metrics: [
        RadarMetric(label: "Clarity", value: 78, color: .orange),
        RadarMetric(label: "Confidence", value: 85, color: .green),
        RadarMetric(label: "Pacing", value: 72, color: .orange),
        RadarMetric(label: "Filler Words", value: 65, color: .orange),
        RadarMetric(label: "Content", value: 90, color: .green)
    ])
    .padding(.all, 24)
}
