//
//  PerformanceRadarChart.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//
import SwiftUI

struct AnimatableVector: VectorArithmetic {
    var values: [Double]

    static var zero = AnimatableVector(values: [])

    static func + (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = max(lhs.values.count, rhs.values.count)
        var result = [Double](repeating: 0, count: count)
        for i in 0..<count {
            let l = i < lhs.values.count ? lhs.values[i] : 0
            let r = i < rhs.values.count ? rhs.values[i] : 0
            result[i] = l + r
        }
        return AnimatableVector(values: result)
    }

    static func - (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = max(lhs.values.count, rhs.values.count)
        var result = [Double](repeating: 0, count: count)
        for i in 0..<count {
            let l = i < lhs.values.count ? lhs.values[i] : 0
            let r = i < rhs.values.count ? rhs.values[i] : 0
            result[i] = l - r
        }
        return AnimatableVector(values: result)
    }

    mutating func scale(by rhs: Double) {
        values = values.map { $0 * rhs }
    }

    var magnitudeSquared: Double {
        values.reduce(0) { $0 + $1 * $1 }
    }
}

struct RadarMetric: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let value: Double // 0...100
    let color: Color
}

struct PerformanceRadarChart: View {
    let metrics: [RadarMetric]

    @State private var animatedValues: [Double]

    init(metrics: [RadarMetric]) {
        self.metrics = metrics
        _animatedValues = State(initialValue: Array(repeating: 0, count: metrics.count))
    }

    private var targetNormalizedValues: [Double] {
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
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedValues = targetNormalizedValues
            }
        }
        .onChange(of: metrics) { newMetrics in
            withAnimation(.easeOut(duration: 0.6)) {
                animatedValues = newMetrics.map { $0.value / 100 }
            }
        }
    }

    // MARK: - Extracted subviews
    private func gridLayer(chartSize: CGFloat) -> some View {
        RadarGridShape(sides: metrics.count, rings: 4)
            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            .frame(width: chartSize, height: chartSize)
    }

    private func fillLayer(chartSize: CGFloat) -> some View {
        RadarShape(values: animatedValues)
            .fill(Color.orange.opacity(0.15))
            .frame(width: chartSize, height: chartSize)
    }

    private func strokeLayer(chartSize: CGFloat) -> some View {
        RadarShape(values: animatedValues)
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

// MARK: - RadarShape needs Animatable support
// Add this to wherever RadarShape is defined:
//
// struct RadarShape: Shape {
//     var values: [Double]
//
//     var animatableData: AnimatableVector {
//         get { AnimatableVector(values: values) }
//         set { values = newValue.values }
//     }
//
//     func path(in rect: CGRect) -> Path {
//         // ...existing path logic using `values`...
//     }
// }

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
