//
//  SwiftUIView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 19/07/2026.
//

import SwiftUI

struct SuggestedSkillChip: View {
    let text: String
    let onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            HStack(spacing: 4) {
                Image(systemName: "plus")
                    .font(.size12Semibold)
                Text(text)
                    .font(.subheadline.bold())
            }
            .foregroundColor(.activeColour)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.activeColour.opacity(0.08))
            )
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SuggestedSkillChip()
//    }
//}
