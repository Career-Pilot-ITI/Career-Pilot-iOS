//
//  SelectedSkillChip.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 19/07/2026.
//

import SwiftUI

struct SelectedSkillChip: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Text(text)
                .font(.size12Semibold)
                .foregroundColor(.primaryNavy)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption.bold())
                    .foregroundColor(.gray400)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.primaryNavy.opacity(0.08))
        )
    }
}

//struct SelectedSkillChip_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedSkillChip(text: "Python", onRemove: {
//            
//        })
//    }
//}
