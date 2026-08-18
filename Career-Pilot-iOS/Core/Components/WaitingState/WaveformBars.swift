//
//  WaveformBars.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import SwiftUI

struct WaveformBars: View {

    let tint: Color
    let isAnimating: Bool

    @State private var animate = false

    private let heights: [CGFloat] = [14, 24, 32, 20, 12]

    var body: some View {

        HStack(spacing: 4) {

            ForEach(0..<heights.count, id: \.self) { index in

                RoundedRectangle(cornerRadius: 2)
                    .fill(tint)
                    .frame(
                        width: 4,
                        height: animate ? heights[index] : 8
                    )
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.12),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = isAnimating
        }
    }
}
