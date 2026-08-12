//
//  AppSearchTextField.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct CustomSearchTextField: View {
    @Binding var text: String
    let placeholder: String
 
    @FocusState var isFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
 
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondary)
 
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .foregroundColor(.gray600)
                .autocorrectionDisabled(true)
                .submitLabel(.search)
                .tint(.primary)
 
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .shadow(
                    color: .black.opacity(colorScheme == .dark ? 0 : 0.06),
                    radius: 8, x: 0, y: 3
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.primary.opacity(isFocused ? 0.12 : 0), lineWidth: 1.5)
                
        }
        .animation(.easeIn(duration: 0.2), value: isFocused)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search tracks")
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var query: String = ""

        var body: some View {
            VStack(spacing: 20) {
                CustomSearchTextField(text: $query, placeholder: "Search tracks…")

                CustomSearchTextField(text: .constant("React"), placeholder: "Search tracks…")
            }
            .padding()
            .background(Color(.systemGroupedBackground))
        }
    }

    return PreviewContainer()
}
