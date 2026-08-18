//
//  Shimmer.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//
import SwiftUI

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -1.5

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            Color.white.opacity(0.55),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geo.size.width * 1.5)
                    .offset(x: phase * geo.size.width)
                    .blendMode(.plusLighter)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.4)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1.5
                }
            }
    }
}

extension View {
    @ViewBuilder
    func shimmering(isActive: Bool) -> some View {
        if isActive {
            self.modifier(Shimmer())
        } else {
            self
        }
    }
}

struct SkeletonBlock: View {
    var height: CGFloat
    var cornerRadius: CGFloat = 16
    var isActive: Bool = true

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color.primary.opacity(0.08),
                        Color.primary.opacity(0.04),
                        Color.primary.opacity(0.08)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: height)
            .shimmering(isActive: isActive)
    }
}

struct SkeletonPill: View {
    var width: CGFloat
    var height: CGFloat = 22
    var isActive: Bool = true

    var body: some View {
        RoundedRectangle(cornerRadius: height / 2, style: .continuous)
            .fill(Color.primary.opacity(0.08))
            .frame(width: width, height: height)
            .shimmering(isActive: isActive)
    }
}

// MARK: - Main Screen

struct ShimmerLoadingView: View {
    var body: some View {
        VStack(spacing: 24) {
            SkeletonBlock(height: 70)
            SkeletonBlock(height: 150)
            SkeletonBlock(height: 165)
            HStack {
                SkeletonPill(width: 130)
                Spacer()
                SkeletonPill(width: 65)
            }
            SkeletonBlock(height: 100)
            SkeletonBlock(height: 100)
            SkeletonBlock(height: 100)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
}

// MARK: - Preview

struct ShimmerLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerLoadingView()
    }
}
