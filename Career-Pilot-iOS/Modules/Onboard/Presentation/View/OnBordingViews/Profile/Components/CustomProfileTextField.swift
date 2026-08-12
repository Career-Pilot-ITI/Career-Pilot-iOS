//
//  CustomProfileTextField.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//
import SwiftUI

struct CustomProfileTextField: View {
    var icon: String
    let title: String
    var autocapitalization: TextInputAutocapitalization?
    @Binding var text: String
    var errorMessage: String? = nil
    
    @FocusState private var isFocused: Bool
    
    private var shouldFloat: Bool {
        isFocused || !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var hasError: Bool {
        errorMessage != nil && !(errorMessage?.isEmpty ?? true)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            HStack(spacing: Spacing.s12) {
                customIcon(icon: icon)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title.uppercased())
                        .font(.caption.bold())
                        .foregroundColor(.gray600)
                        .opacity(shouldFloat ? 1.0 : 0.0)
                        .frame(height: shouldFloat ? nil : 0, alignment: .leading)
                        .clipped()
                    
                    TextField(title.uppercased(), text: $text)
                        .textInputAutocapitalization(autocapitalization)
                        .font(shouldFloat ? .size13Semibold : .size14Medium)
                        .foregroundColor(shouldFloat ? .primaryNavy : .gray400)
                        .focused($isFocused)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .frame(height: 1)
                        .background(dividerColor)
                }
                .animation(.easeOut(duration: 0.2), value: shouldFloat)
            }
            .padding(.vertical, Spacing.s8)
            
            // Error Message View
            if let error = errorMessage, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 56) // 44px icon + 12px spacing alignment
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }
    
    private var dividerColor: Color {
        if hasError {
            return .red
        }
        return isFocused ? Color.activeColour : Color.gray400
    }
    
    @ViewBuilder
    private func customIcon(icon: String) -> some View {
        Image(icon)
            .foregroundColor(.primaryNavy)
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: Radius.r12)
                    .fill(Color.primaryNavy.opacity(0.06))
            )
    }
}


