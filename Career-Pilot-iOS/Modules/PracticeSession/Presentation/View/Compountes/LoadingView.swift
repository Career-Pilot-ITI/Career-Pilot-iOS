//
//  LoadingView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {

            SoundWaveView(color: .primaryTeal)

            Text("Loading…")
                .font(.title2.bold())
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkBackGround.ignoresSafeArea())

    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
