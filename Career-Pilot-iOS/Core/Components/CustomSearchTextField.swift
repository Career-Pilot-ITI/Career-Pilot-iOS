//
//  AppSearchTextField.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct CustomSearchTextField: View {
    @Binding var text: String
    let placeholder: String = "Search tracks…"
    
    @FocusState var isFocused : Bool
    
    var body: some View {
        HStack(spacing:10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.black.opacity(0.35))
            
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .foregroundColor(.black)
                .autocorrectionDisabled(true)
                .submitLabel(.search)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color.black.opacity(0.25))
                }
                .accessibilityLabel("Clear search")
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
        }
        .overlay {
            RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                .stroke(Color.black.opacity(isFocused ? 0.12 : 0), lineWidth: 1.5)
        }
        .animation(.easeIn(duration: 0.2), value: isFocused)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search tracks")
    }
}

