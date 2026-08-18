//
//  RetryableErrorView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/08/2026.
//
import SwiftUI

struct RetryableErrorView: View {
    let title: String
    let message: String
    let onRetry: () -> Void
    
    var icon: String = "exclamationmark.triangle.fill"
    var iconColor: Color = .errorColour
    var retryTitle: String = "Try Again"
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(iconColor)
            
            Text(title)
                .font(.size16Bold)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.gray400)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: onRetry) {
                Text(retryTitle)
                    .font(.size14Medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.matchAmber))
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 250)
        .padding(.top, 40)
    }
}
