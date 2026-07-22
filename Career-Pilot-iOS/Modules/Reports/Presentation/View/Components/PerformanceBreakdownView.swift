//
//  PerformanceBreakdownView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct PerformanceBreakdownView: View {
    let metrics: [RadarMetric]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Performance Breakdown")
                .font(Font.size12Bold)
                .foregroundStyle(Color.gray600)
                .padding(.bottom, 4)
            
            PerformanceRadarChart(metrics: metrics)
                .frame(height: 300)
                .padding(.bottom, 12)
            
            RadarMetricsLegend(metrics: metrics)
        }
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(.white)
        }
    }
}

#Preview {
    ZStack() {
        Color.lightBackGround
        VStack {
            Spacer()
            PerformanceBreakdownView(metrics: [
                RadarMetric(label: "Clarity", value: 78, color: .orange),
                RadarMetric(label: "Confidence", value: 85, color: .green),
                RadarMetric(label: "Pacing", value: 72, color: .orange),
                RadarMetric(label: "Filler Words", value: 65, color: .orange),
                RadarMetric(label: "Content", value: 90, color: .green)
            ])
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
