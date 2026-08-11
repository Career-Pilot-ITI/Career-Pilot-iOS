//
//  SuggestedEditCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//

import SwiftUI

struct SuggestedEditCard: View {
    let edit: SuggestedEdit

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: edit.icon.rawValue)
                .font(Font.size15Medium)
                .foregroundColor(Color.accentTeal)
                .frame(width: 36, height: 36)
                .background(Color.accentTealBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(edit.title)
                        .font(Font.size13Bold)
                        .foregroundColor(Color.textPrimary)
                    Spacer()
                    PriorityBadge(priority: edit.impact, customText: "\(edit.impact.rawValue) impact")
                }
                
                Text(edit.description)
                    .font(.system(size: 12.5,weight: .regular))
                    .foregroundColor(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16))
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    SuggestedEditCard(edit: SuggestedEdit.mockSingle)
        .padding()
}

private extension SuggestedEdit {
    static let mockSingle = SuggestedEdit(
        icon: .skills,
        title: "Add Kubernetes to Skills",
        impact: .high,
        description: "The role requires container orchestration. Add Kubernetes to your Skills section and briefly mention any hands-on experience."
    )
}
