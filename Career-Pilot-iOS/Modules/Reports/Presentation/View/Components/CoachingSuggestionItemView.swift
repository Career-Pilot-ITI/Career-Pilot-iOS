//
//  CoachingSuggestionItemView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//
import SwiftUI

struct CoachingSuggestionItemView: View {
    let suggestion: CoachingSuggestion
    @State private var isExpanded: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            SuggestionIconView(icon: suggestion.icon)

            VStack(alignment: .leading, spacing: Spacing.s4) {
                HStack(spacing: Spacing.s8) {
                    Text(suggestion.text)
                        .font(Font.size14Bold)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)

                    ImpactBadge(level: suggestion.badgeLevel)

                    Spacer(minLength: 0)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.gray600)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }

                if isExpanded {
                    Text(suggestion.description)
                        .font(Font.size13Regular)
                        .foregroundStyle(Color.gray600)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                } else {
                    Text(suggestion.description)
                        .font(Font.size13Regular)
                        .foregroundStyle(Color.gray600)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color.gray400.opacity(0.08))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.25)) {
                isExpanded.toggle()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
    }
}

//#Preview {
//    ZStack {
//        Color.lightBackGround
//        VStack {
//            Spacer()
//            CoachingSuggestionItemView(
//                suggestion: CoachingSuggestion(
//                    icon: "target",
//                    text: "Prepare a technical primer on Jetpack Compose state management, specifically focusing on 'remember', 'derivedStateOf', and state hoisting",
//                    description: "Focus on remember, derivedStateOf, and state hoisting to avoid blank responses during technical deep-dives.",
//                    badgeLevel: "High impact"
//                )
//            )
//            Spacer()
//        }
//        .padding(.horizontal, 24)
//    }
//}
