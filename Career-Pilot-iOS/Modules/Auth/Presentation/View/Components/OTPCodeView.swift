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
    var resendInterval: Int = 60
    var onComplete: (String) -> Void = { _ in }
    var onResend: () -> Void = {}

    @FocusState private var isFocused: Bool
    @State private var secondsRemaining: Int = 0

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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

                HStack(spacing: 0) {
                    ForEach(0..<length, id: \.self) { index in
                        OTPBoxView(character: character(at: index),
                                   isActive: index == code.count && isFocused)
                            .padding(.horizontal, 5)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { isFocused = true }
            }
            .padding(12)

            HStack {
                resendText
                Spacer()
                Button(action: handleResendTap) {
                    Text("Resend")
                        .font(.subheadline)
                        .foregroundColor(secondsRemaining > 0 ? AppColors.OTPField.otpSecondaryText.opacity(0.5) : Color.primary)
                }
                .disabled(secondsRemaining > 0)
            }
            .padding(.top, 18)
        }
        .onAppear {
            isFocused = true
            startTimer()
        }
        .onReceive(timer) { _ in
            guard secondsRemaining > 0 else { return }
            secondsRemaining -= 1
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

    private func startTimer() {
        secondsRemaining = resendInterval
    }

    private func handleResendTap() {
        guard secondsRemaining == 0 else { return }
        code = ""
        isFocused = true
        startTimer()
        onResend()
    }

    private var resendText: some View {
        Group {
            if secondsRemaining > 0 {
                (Text("Resend in ")
                    .foregroundColor(AppColors.OTPField.otpSecondaryText)
                 +
                 Text(timeString(secondsRemaining))
                    .foregroundColor(AppColors.OTPField.otpAccent)
                )
                .font(.subheadline)
            } else {
                Text(" ")
                    .font(.subheadline)
            }
        }
    }

    private func timeString(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

private struct OTPPreviewWrapper: View {
    let code: String

    var body: some View {
        ZStack {
            AppColors.OTPField.otpBackground.ignoresSafeArea()
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
