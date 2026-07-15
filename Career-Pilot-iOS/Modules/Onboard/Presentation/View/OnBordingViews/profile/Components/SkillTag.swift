//
//  SkillTag.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct SkillTag: View {
    let text: String
    var isMuted: Bool = false
    var body: some View {
        Text(text)
              .font(.subheadline.bold())
              .foregroundColor(isMuted ? .gray400 : .primaryNavy)
              .padding(.horizontal, 16)
              .padding(.vertical, 10)
              .background(
                  Capsule().fill(Color.gray100.opacity(isMuted ? 0.5 : 1))
              )
    }
}


