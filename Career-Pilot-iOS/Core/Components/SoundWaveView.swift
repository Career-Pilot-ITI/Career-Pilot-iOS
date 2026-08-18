//
//  SoundWaveView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

/*
 customized:
    SoundWaveView(barCount: 24, color: .primaryTeal, maxHeight: 36)
*/

import SwiftUI
 
struct SoundWaveView: View {
    var barCount: Int = 20
    var color: Color = .primaryTeal
    var minHeight: CGFloat = 4
    var maxHeight: CGFloat = 56
    var barWidth: CGFloat = 3
    var spacing: CGFloat = 4
    var animationSpeed: Double = 0.35
 
    @State private var heights: [CGFloat] = []
 
    var body: some View {
        HStack(alignment: .bottom, spacing: spacing) {
            ForEach(0..<barCount, id: \.self) { index in
                Capsule()
                    .fill(color)
                    .frame(width: barWidth, height: heights.indices.contains(index) ? heights[index] : minHeight)
            }
        }
        .frame(height: maxHeight, alignment: .bottom)
        .onAppear {
            heights = randomHeights()
            animateWave()
        }
    }
 
    private func randomHeights() -> [CGFloat] {
        (0..<barCount).map { _ in CGFloat.random(in: minHeight...maxHeight) }
    }
 
    private func animateWave() {
        withAnimation(.easeInOut(duration: animationSpeed)) {
            heights = randomHeights()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationSpeed) {
            animateWave()
        }
    }
}
 
//#Preview {
//    ZStack {
//        AppColors.OTPField.otpBackground.ignoresSafeArea()
//        SoundWaveView()
//    }
//}
//
//
