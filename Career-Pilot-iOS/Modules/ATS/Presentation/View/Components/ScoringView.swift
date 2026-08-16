//
//  ScoreRingView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//

import SwiftUI

struct ScoreRingView: View {
    let score: Int
    var size: CGFloat = 72
    var lineWidth: CGFloat = 6
    var color: Color = Color.accentTeal

    private var progress: CGFloat {
        CGFloat(min(max(score, 0), 100)) / 100
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.15), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(score)")
                .font(Font.size19Bold)
                .foregroundColor(Color.textPrimary)
        }
        .frame(width: size, height: size)
        .animation(.easeOut(duration: 0.6), value: score)
    }
}

struct ScoreProgressBar: View {
    let progress: Double // 0...1
    var color: Color = Color.accentTeal

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(color.opacity(0.15))
                Capsule().fill(color)
                    .frame(width: geo.size.width * progress)
            }
        }
        .frame(height: 6)
    }
}
//
//#Preview {
//    VStack(spacing: 24) {
//        ScoreRingView(score: 73)
//        ScoreProgressBar(progress: 0.73)
//            .padding(.horizontal)
//    }
//    .padding()
//}
