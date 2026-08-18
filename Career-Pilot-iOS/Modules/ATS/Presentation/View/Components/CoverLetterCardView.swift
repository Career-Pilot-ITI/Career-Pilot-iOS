//
//  CoverLetterCardView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import SwiftUI

struct CoverLetterCardView: View {
    let data: CoverLetterData
    var onEdit: () -> Void = {}
    var onCopy: () -> Void = {}

    private var bodyParagraphs: [String] {
        Array(data.paragraphs.dropLast())
    }

    private var closing: String {
        data.paragraphs.last ?? "Sincerely,"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Label("Cover Letter", systemImage: "doc.text")
                    .font(.system(size: 14, weight: .medium))

                Spacer()

                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color.screenBackground)
                        .clipShape(Capsule())
                }

                Button(action: onCopy) {
                    Label("Copy", systemImage: "doc.on.doc")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color.screenBackground)
                        .clipShape(Capsule())
                }
            }

            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(bodyParagraphs.enumerated()), id: \.offset) { _, paragraph in
                    Text(paragraph)
                        .font(.system(size: 14))
                        .foregroundColor(.primary.opacity(0.85))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(closing)
                    .font(.system(size: 14))
                    .foregroundColor(.primary.opacity(0.85))

                HStack(spacing: 8) {
                    if !data.signature.name.isEmpty {
                        ContactChip(text: data.signature.name, kind: .name)
                    }
                    if !data.signature.email.isEmpty {
                        ContactChip(text: data.signature.email, kind: .email)
                    }
                    if !data.signature.phone.isEmpty {
                        ContactChip(text: data.signature.phone, kind: .phone)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.gray400.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }
}

//#Preview {
//    ScrollView {
//        CoverLetterCardView(data: .sample)
//            .padding()
//    }
//    .background(Color.screenBackground)
//}
