//
//  SwiftUIView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//

import SwiftUI

struct SessionRowSkeleton: View {
    var body: some View {
        HStack(spacing: Spacing.s16) {
            RoundedRectangle(cornerRadius: Radius.r14)
                .fill(Color(.systemGray5))
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: Spacing.s8) {
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(height: 16)
                    .frame(width: 160)
                
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(height: 12)
                    .frame(width: 90)
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: Radius.r6) 
                .fill(Color(.systemGray5))
                .frame(width: 50, height: 28)
        }
        .padding(Spacing.s16)
        .background(Color.background)
        .cornerRadius(Radius.r16)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.r16)
                .stroke(Color(.systemGray6), lineWidth: 1)
        )
        .shimmering()
    }
}
