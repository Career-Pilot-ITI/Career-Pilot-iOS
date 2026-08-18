//
//  TrackChip.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 16/07/2026.
//

import SwiftUI

struct TrackChip: View {

    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.subheadline)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? Color.primary : .gray200.opacity(0.7))
            )
            .overlay(
                Capsule()
                    .stroke(Color.gray.opacity(0.6))
            )
            .foregroundStyle(isSelected ? .white : .black)
    }
}
struct TrackChip_Previews: PreviewProvider {
    static var previews: some View {
        TrackChip(title: "Testing", isSelected: false)
    }
}
