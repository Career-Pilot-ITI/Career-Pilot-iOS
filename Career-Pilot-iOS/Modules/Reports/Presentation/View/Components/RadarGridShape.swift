//
//  RadarGridShape.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct RadarGridShape: Shape {
    let sides: Int
    let rings: Int // how many concentric levels

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let angleStep = (2 * Double.pi) / Double(sides)
        var path = Path()

        // Concentric rings
        for ring in 1...rings {
            let ringRadius = radius * CGFloat(ring) / CGFloat(rings)
            var ringPath = Path()
            for i in 0..<sides {
                let angle = angleStep * Double(i) - .pi / 2
                let point = CGPoint(
                    x: center.x + CGFloat(cos(angle)) * ringRadius,
                    y: center.y + CGFloat(sin(angle)) * ringRadius
                )
                if i == 0 { ringPath.move(to: point) } else { ringPath.addLine(to: point) }
            }
            ringPath.closeSubpath()
            path.addPath(ringPath)
        }

        // Spokes from center to each axis
        for i in 0..<sides {
            let angle = angleStep * Double(i) - .pi / 2
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            path.move(to: center)
            path.addLine(to: point)
        }

        return path
    }
}
