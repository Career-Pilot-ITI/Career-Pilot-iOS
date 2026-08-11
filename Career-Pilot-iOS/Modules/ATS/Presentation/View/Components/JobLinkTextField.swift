//
//  JobLinkTextField.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//
import SwiftUI

struct JobLinkTextField: View {
    @Binding var link: String

    var body: some View {
        HStack(spacing: Spacing.s8) {
            Image(systemName: "arrow.up.forward.square")
                .foregroundStyle(Color.textSecondary)

            TextField("https://linkedin.com/jobs/view/...", text: $link)
                .font(Font.size14Regular)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(Spacing.s16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .fill(.white)
        }
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    JobLinkTextField(link: .constant(""))
        .padding()
}
