//
//  JobLinkShareTipView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 08/08/2026.
//

import SwiftUI

struct JobLinkShareTipView: View {
    private let fullText = "Faster: In LinkedIn or any job app — tap Share → CareerPilot. The link is captured automatically."

    @State private var visibleCount: Int = 0
    @State private var hasAnimated = false

    private let timer = Timer.publish(every: 0.04, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            Image(systemName: "sparkles")
                .foregroundStyle(Color.primaryTeal)

            animatedText
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.s16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color.primaryTeal)
                .opacity(0.05)
        }
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16)
                .stroke(Color.primaryTeal.opacity(0.3), lineWidth: 1)
        }
        .accessibilityLabel(Text(fullText))
        .onAppear {
            guard !hasAnimated else { return }
            visibleCount = 0
        }
        .onReceive(timer) { _ in
            guard !hasAnimated, visibleCount < fullText.count else {
                if visibleCount >= fullText.count { hasAnimated = true }
                return
            }
            visibleCount += 1
        }
    }

    @ViewBuilder
    private var animatedText: some View {
        let visible = String(fullText.prefix(visibleCount))
        let segments = buildSegments(from: visible)

        var result = Text("")
        for segment in segments {
            let t = Text(segment.text)
            result = result + (segment.isBold ? t.fontWeight(.bold) : t)
        }
        result
            .foregroundStyle(Color.primaryTeal)
            .font(Font.size12Medium)
    }

    private struct Segment {
        let text: String
        let isBold: Bool
    }

    private func buildSegments(from text: String) -> [Segment] {
        let boldRanges: [(String, String)] = [
            ("Faster: ", "Faster: "),
            ("Share → CareerPilot", "Share → CareerPilot")
        ]

        var segments: [Segment] = []
        var currentIndex = text.startIndex

        while currentIndex < text.endIndex {
            var bestMatch: (range: Range<String.Index>, boldText: String)?
            var bestStart = text.endIndex

            for (searchText, boldText) in boldRanges {
                if let searchRange = text.range(of: searchText, range: currentIndex..<text.endIndex),
                   searchRange.lowerBound < bestStart {
                    bestMatch = (searchRange, boldText)
                    bestStart = searchRange.lowerBound
                }
            }

            if let match = bestMatch {
                if currentIndex < match.range.lowerBound {
                    let plain = String(text[currentIndex..<match.range.lowerBound])
                    segments.append(Segment(text: plain, isBold: false))
                }
                let bold = String(text[match.range])
                segments.append(Segment(text: bold, isBold: true))
                currentIndex = match.range.upperBound
            } else {
                let remaining = String(text[currentIndex..<text.endIndex])
                if !remaining.isEmpty {
                    segments.append(Segment(text: remaining, isBold: false))
                }
                currentIndex = text.endIndex
            }
        }

        return segments
    }
}
