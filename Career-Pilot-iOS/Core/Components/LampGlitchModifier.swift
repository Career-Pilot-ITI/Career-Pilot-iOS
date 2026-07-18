//
//  LampGlitchModifier.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 18/07/2026.
//

import SwiftUI

struct LampGlitchModifier: ViewModifier {
    var isActive: Bool
    @State private var isDim = false
    @State private var timer: Timer?

    func body(content: Content) -> some View {
        content
            .brightness(isActive && isDim ? -0.4 : 0)
            .saturation(isActive && isDim ? 0.3 : 1.0)
            .opacity(isActive && isDim ? 0.45 : 1.0)
            .onChange(of: isActive) { active in
                active ? startFlicker() : stopFlicker()
            }
            .onDisappear { stopFlicker() }
    }

    private func startFlicker() {
        scheduleNext()
    }

    private func scheduleNext() {
        let delay = Double.random(in: 0.08...0.35)
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            guard isActive else { return }
            withAnimation(.easeInOut(duration: Double.random(in: 0.03...0.1))) {
                isDim.toggle()
            }
            scheduleNext()
        }
    }

    private func stopFlicker() {
        timer?.invalidate()
        timer = nil
        isDim = false
    }
}

extension View {
    func lampGlitch(isActive: Bool) -> some View {
        modifier(LampGlitchModifier(isActive: isActive))
    }
}
