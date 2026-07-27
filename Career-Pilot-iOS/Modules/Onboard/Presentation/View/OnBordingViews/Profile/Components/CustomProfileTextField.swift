//
//  CustomProfileTextField.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//
import SwiftUI

import SwiftUI

struct CustomProfileTextField: View {
    var icon: String
    let title: String
    @Binding var text: String
    var errorMessage: String? = nil // Optional error message string
    @FocusState private var isFocused: Bool
    
    private var shouldFloat: Bool {
        isFocused || !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var hasError: Bool {
        errorMessage != nil && !(errorMessage?.isEmpty ?? true)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                customIcon(icon: icon)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title.uppercased())
                        .font(.caption.bold())
                        .foregroundColor(.gray600)
                        .opacity(shouldFloat ? 1.0 : 0.0)
                        .frame(height: shouldFloat ? nil : 0, alignment: .leading)
                        .clipped()

                    TextField(title.uppercased(), text: $text)
                        .font(shouldFloat ? .size13Semibold : .size14Medium)
                        .foregroundColor(shouldFloat ? .primaryNavy : .gray400)
                        .focused($isFocused)
                        .frame(width: 210)
                    
                    Divider()
                        .frame(width: 210, height: 1)
                        .background(dividerColor)
                }
                .animation(.easeOut(duration: 0.2), value: shouldFloat)
            }
            .padding(.vertical, Spacing.s12)
            
            // Error Message View
            if let error = errorMessage, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 56) // Aligns text nicely past the 44px icon + 12px spacing
            }
        }
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
//struct CustomProfileTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomProfileTextField()
//    }
//}

