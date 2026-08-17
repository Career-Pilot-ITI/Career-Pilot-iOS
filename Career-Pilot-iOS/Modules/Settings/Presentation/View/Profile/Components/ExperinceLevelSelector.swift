//
//  ExprinceLevelSelector.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import SwiftUI

struct ExperienceLevelSelector: View {
    let options = ["Junior", "Mid-Level", "Senior"]
    @Binding var selected: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image("experienceLevel")
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: Radius.r12)
                        .fill(Color.primary.opacity(0.6))
                ).padding(.trailing,8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("EXPERIENCE LEVEL")
                    .font(.caption.bold())
                    .foregroundColor(.gray400)
                
                HStack(spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                            .font(.size13Medium.bold())
                            .foregroundColor(selected == option ? .white : .gray400)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(selected == option ? Color.primary : Color.gray100)
                            )
                            .onTapGesture {
                                selected = option
                            }
                    }
                }
            }.frame(maxWidth: .infinity)
            Spacer()
        }
    }
}
