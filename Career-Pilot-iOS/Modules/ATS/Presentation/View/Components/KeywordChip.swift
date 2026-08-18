//
//  KeywordChip.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//

import SwiftUI

struct KeywordChip: View {
    let text: String
 
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark")
                .font(.system(size: 11, weight: .bold))
            Text(text)
                .font(.system(size: 14, weight: .medium))
        }
        .foregroundColor(Color.accentTeal)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.accentTealBackground)
        .clipShape(Capsule())
    }
}
 
 
//#Preview {
//    FlowLayout {
//        ForEach(["React", "TypeScript", "Node.js", "System Design", "AWS"], id: \.self) { KeywordChip(text: $0) }
//    }
//    .padding()
//}
// 
