//
//  UploadedCVCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//
import SwiftUI

struct UploadedCVCard: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            StatusBadge(badge: "doc.text", color: Color.activeColour)

            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text("resume_sarah_chen.pdf")
                    .font(Font.size14Bold)

                Text("Uploaded 12 Jun 2025 · 284 KB")
                    .font(Font.size12Regular)
            }
            Spacer()
            StatusBadge(badge: "checkmark.circle", color: Color.green, padding: 6, frame: (28, 28))
        }
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
            .fill(Color.gray400.opacity(0.08))
        }
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }
}

//#Preview {
//    UploadedCVCard()
//        .padding()
//        .background(Color(white: 0.95))
//}
