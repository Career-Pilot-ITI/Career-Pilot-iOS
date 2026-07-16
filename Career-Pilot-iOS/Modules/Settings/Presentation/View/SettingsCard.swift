//
//  SettingsCard.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct SettingsCard: View {
    var leadingIcon : String
    var title : String
    var subtitle : String
    
    var body: some View {
        HStack(spacing: 12) {
            CustomIcon(icon: leadingIcon )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.size32Bold)
                    .foregroundColor(.primaryNavy)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray400)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray400)
                .font(.caption.bold())
        }
        .padding(.vertical, 8)
    }
    private func CustomIcon(icon: String) -> some View {
        Image(icon)
            .foregroundColor(.primaryNavy)
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: Radius.r12)
                    .fill(Color.primaryNavy.opacity(0.06))
            )
    }
}

//struct SettingsCard_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsCard()
//    }
//}


