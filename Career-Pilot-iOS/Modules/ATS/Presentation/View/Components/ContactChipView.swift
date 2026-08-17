//
//  ContactChipView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//
import SwiftUI

enum ContactChipKind {
    case name
    case email
    case phone

    var icon: String {
        switch self {
        case .name: return "person.fill"
        case .email: return "envelope.fill"
        case .phone: return "phone.fill"
        }
    }

    var foreground: Color {
        switch self {
        case .name: return .purple
        case .email: return .matchGreen
        case .phone: return .matchOrange
        }
    }

    var background: Color {
        switch self {
        case .name: return Color.purple.opacity(0.12)
        case .email: return .greenChipBg
        case .phone: return .redChipBg
        }
    }
}

struct ContactChip: View {
    let text: String
    let kind: ContactChipKind

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: kind.icon)
                .font(.system(size: 10, weight: .bold))
            Text(text)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(kind.foreground)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(kind.background)
        .clipShape(Capsule())
    }
}

//#Preview {
//    HStack {
//        ContactChip(text: "Sarah Chen", kind: .name)
//        ContactChip(text: "sarah@email.com", kind: .email)
//        ContactChip(text: "+20 10 1234 5678", kind: .phone)
//    }
//    .padding()
//    .background(Color.screenBackground)
//}
