//
//  RadarShape.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct RadarShape: Shape {
    let values: [Double] // normalized 0...1, in axis order
    let maxValue: Double = 1.0

    func path(in rect: CGRect) -> Path {
        guard !values.isEmpty else { return Path() }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let angleStep = (2 * Double.pi) / Double(values.count)

        var path = Path()

        for (index, value) in values.enumerated() {
            let normalized = min(max(value / maxValue, 0), 1)
            // Start from top (-90°) and go clockwise
            let angle = angleStep * Double(index) - .pi / 2
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius * CGFloat(normalized),
                y: center.y + CGFloat(sin(angle)) * radius * CGFloat(normalized)
            )
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}
