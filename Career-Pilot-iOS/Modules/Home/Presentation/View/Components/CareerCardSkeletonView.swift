//
//  SwiftUIView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//

import SwiftUI

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.5),
                            Color.white.opacity(0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + (phase * (geometry.size.width * 2)))
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1.0
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        modifier(ShimmerEffect())
    }
}

struct CareerCardSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color(.systemGray5))
                .frame(width: 56, height: 56)
            
            VStack(alignment: .leading, spacing: Spacing.s8) {
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(height: 18)
                    .frame(width: 140)
                
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(height: 18)
                    .frame(width: 100)
            }
            
            Capsule()
                .fill(Color(.systemGray5))
                .frame(width: 90, height: 24)
            
            Spacer()
            
            HStack {
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(width: 60, height: 16)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: Radius.r14)
                    .fill(Color(.systemGray5))
                    .frame(width: 48, height: 48)
            }
        }
        .padding(Spacing.s24)
        .frame(width: 200, height: 250)
        .background(Color.white)
        .cornerRadius(Radius.r24)
        .shadow(color: Color.black.opacity(0.03), radius: Radius.r16, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.r24)
                .stroke(Color(.systemGray6), lineWidth: 1)
        )
        .shimmering()
    }
}
