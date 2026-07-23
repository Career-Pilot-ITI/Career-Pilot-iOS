//
//  TranscriptSnippetCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct TranscriptSnippetCard: View {
    let transcript: String
    let flaggedWords: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Transcript Snippet")
                .font(Font.size14Bold)
                .foregroundStyle(Color.primaryNavy)

            Text("\"\(transcript)\"")
                .font(Font.size13Regular)
                .italic()
                .foregroundStyle(Color.gray600)

            FlowLayout(spacing: Spacing.s8) {
                ForEach(flaggedWords, id: \.self) { word in
                    Text(word)
                        .font(Font.size12Bold)
                        .foregroundStyle(Color.red)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background {
                            Capsule()
                                .fill(Color.red.opacity(0.1))
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(.white)
        }
    }
}
//
//#Preview {
//    TranscriptSnippetCard(transcript: "\"So, uh, I think the main challenge was… um… basically we had to figure out how the architecture would, you know, handle the load…\"", flaggedWords: ["uh" , "um" , "you know" , "basically"])
//}
