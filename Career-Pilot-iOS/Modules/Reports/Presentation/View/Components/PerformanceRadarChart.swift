//
//  PerformanceRadarChart.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct RadarMetric: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let value: Double // 0...100
    let color: Color
}
struct PerformanceRadarChart: View {
    let metrics: [RadarMetric]

    private var normalizedValues: [Double] {
        metrics.map { $0.value / 100 }
    }

    var body: some View {
        GeometryReader { geo in
            let labelInset: CGFloat = 44
            let chartSize: CGFloat = min(geo.size.width, geo.size.height) - (labelInset * 2)
            let center: CGFloat = geo.size.width / 2

            ZStack {
                gridLayer(chartSize: chartSize)
                fillLayer(chartSize: chartSize)
                strokeLayer(chartSize: chartSize)
                labelsLayer(chartSize: chartSize, center: center)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    // MARK: - Extracted subviews

    private func gridLayer(chartSize: CGFloat) -> some View {
        RadarGridShape(sides: metrics.count, rings: 4)
            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            .frame(width: chartSize, height: chartSize)
    }

    private func fillLayer(chartSize: CGFloat) -> some View {
        RadarShape(values: normalizedValues)
            .fill(Color.orange.opacity(0.15))
            .frame(width: chartSize, height: chartSize)
    }

    private func strokeLayer(chartSize: CGFloat) -> some View {
        RadarShape(values: normalizedValues)
            .stroke(Color.orange, lineWidth: 2)
            .frame(width: chartSize, height: chartSize)
    }

    private func labelsLayer(chartSize: CGFloat, center: CGFloat) -> some View {
        ForEach(Array(metrics.enumerated()), id: \.element.id) { index, metric in
            labelView(index: index, metric: metric, chartSize: chartSize, center: center)
        }
    }

    private func labelView(index: Int, metric: RadarMetric, chartSize: CGFloat, center: CGFloat) -> some View {
        let angle: Double = (2 * Double.pi / Double(metrics.count)) * Double(index) - .pi / 2
        let labelRadius: CGFloat = (chartSize / 2) + 24
        let x: CGFloat = center + CGFloat(cos(angle)) * labelRadius
        let y: CGFloat = center + CGFloat(sin(angle)) * labelRadius

        return Text(metric.label)
            .font(Font.size11Bold)
            .foregroundStyle(Color.gray600)
            .fixedSize()
            .position(x: x, y: y)
    }
}

//#Preview {
//    PerformanceRadarChart(metrics: [
//        RadarMetric(label: "Clarity", value: 78, color: .orange),
//        RadarMetric(label: "Confidence", value: 85, color: .green),
//        RadarMetric(label: "Pacing", value: 72, color: .orange),
//        RadarMetric(label: "Filler Words", value: 65, color: .orange),
//        RadarMetric(label: "Content", value: 90, color: .green)
//    ])
//    .padding(.all, 24)
//}
