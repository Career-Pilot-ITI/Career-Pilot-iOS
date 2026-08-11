//
//  StrengthsWeaknessesView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import SwiftUI

private struct BulletList: View {
    let items: [String]
    let dotColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(dotColor)
                        .frame(width: 5, height: 5)
                        .padding(.top, 7)
                    Text(item)
                        .font(.system(size: 14))
                        .foregroundColor(.primary.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

struct StrengthsCard: View {
    let strengths: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text("Strengths")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.matchGreen)
            } icon: {
                Image(systemName: "hand.thumbsup.fill")
                    .foregroundColor(.matchGreen)
            }

            BulletList(items: strengths, dotColor: .matchGreen)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.greenCardBg)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }
}

struct WeaknessesCard: View {
    let weaknesses: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text("Weaknesses")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.matchAmber)
            } icon: {
                Image(systemName: "hand.thumbsdown.fill")
                    .foregroundColor(.matchAmber)
            }

            BulletList(items: weaknesses, dotColor: .matchAmber)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.amberCardBg)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 16) {
        StrengthsCard(strengths: JobMatchData.sample.strengths)
        WeaknessesCard(weaknesses: JobMatchData.sample.weaknesses)
    }
    .padding()
    .background(Color.screenBackground)
}
