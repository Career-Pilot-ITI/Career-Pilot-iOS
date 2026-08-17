//
//  JobPostingLinkTextField.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//

import SwiftUI

struct JobPostingLinkTextField: View {
    @Binding var text: String
    let placeholder: String

    @FocusState var isFocused : Bool
    var body: some View {
        HStack(spacing:Spacing.s12) {
            Image(systemName: "arrow.up.right.square")
                .font(Font.size13Regular)
                .foregroundColor(Color.gray400)
            
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
                        .foregroundColor(Color.gray400)
                }
                .accessibilityLabel("Clear search")
            }
            
        }
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
        }
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(isFocused ? 0.12 : 0), lineWidth: 1.5)
        }
        .animation(.easeIn(duration: 0.2), value: isFocused)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search tracks")
    }
}

//#Preview {
//    JobPostingLinkTextField(text: .constant(""), placeholder: "https://linkedin.com/jobs/view/…")
//}
