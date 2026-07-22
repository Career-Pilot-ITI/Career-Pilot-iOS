//
//  CoachingSuggestionItemView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct CoachingSuggestionItemView: View {
    let suggestion : CoachingSuggestion
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            SuggestionIconView(icon: suggestion.icon)
            VStack(alignment: .leading, spacing: Spacing.s4) {
                HStack(spacing: Spacing.s8) {
                    Text(suggestion.text)
                        .font(Font.size14Bold)
                        .foregroundStyle(Color.primaryNavy)
                    
                    ImpactBadge(level: suggestion.badgeLevel)
                    
                    Spacer()
                }
                
                Text(suggestion.description)
                    .font(Font.size13Regular)
                    .foregroundStyle(Color.gray600)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
        }
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius:Radius.r16)
                .fill(.white)
        }
    }
}

#Preview {
    ZStack() {
        Color.lightBackGround
        VStack {
            Spacer()
            CoachingSuggestionItemView(
            suggestion: CoachingSuggestion(icon: "target", text: "Reduce filler words", description: "You used 'um' and 'uh' 14 times. Try pausing silently instead.", badgeLevel: "High impact"))
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
