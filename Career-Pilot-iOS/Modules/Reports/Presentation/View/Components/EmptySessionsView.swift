//
//  EmptySessionsView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 13/08/2026.
//

import SwiftUI

struct EmptySessionsView: View {

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(Color.gray400)
                .padding(.bottom, 4)

            Text("No sessions yet")
                .font(.headline)
                .foregroundStyle(Color.gray600)

            Text("Your practice sessions will show up here once you complete one.")
                .font(.subheadline)
                .foregroundStyle(Color.gray400)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
