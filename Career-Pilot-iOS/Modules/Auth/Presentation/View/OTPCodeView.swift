//
//  OTPCodeView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 14/07/2026.
//

import SwiftUI

struct OTPCodeView: View {
    
    @Binding var code: String
    var length: Int = 6
    var phoneNumber: String = ""
    var onComplete: (String) -> Void = { _ in }
    var onResend: () -> Void = {}
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isFocused)
                    .opacity(0)
                    .frame(width: 1, height: 1)
                    .onChange(of: code) { newValue in
                        filterAndClamp(newValue)
                    }
                
                HStack(spacing: 10) {
                    ForEach(0..<length, id: \.self) { index in
                        OTPBoxView(character: character(at: index),
                                   isActive: index == code.count && isFocused)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { isFocused = true }
            }
            .padding(.top, 8)
        }
        .onAppear {
            isFocused = true
        }
    }
    
    
    private func character(at index: Int) -> String {
        guard index < code.count else { return "" }
        let charIndex = code.index(code.startIndex, offsetBy: index)
        return String(code[charIndex])
    }
    
    private func filterAndClamp(_ newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        let clamped = String(filtered.prefix(length))
        if clamped != newValue {
            code = clamped
        }
        if clamped.count == length {
            isFocused = false
            onComplete(clamped)
        }
    }
}

private struct OTPPreviewWrapper: View {
    let code: String
    
    var body: some View {
        ZStack {
            Color.otpBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                OTPCodeView(code: .constant(code), length: 6, phoneNumber: "+20 101 234 5678")
            }
            .padding(.horizontal, 24)
        }
        .preferredColorScheme(.dark)
    }
}

struct FilledState_PreviewContainer: PreviewProvider {
    static var previews: some View {
        OTPPreviewWrapper(code: "123456")
            .previewDisplayName("Filled state")
    }
}	

struct EmptyState_PreviewContainer: PreviewProvider {
    static var previews: some View {
        OTPPreviewWrapper(code: "")
            .previewDisplayName("Empty state")
    }
}
