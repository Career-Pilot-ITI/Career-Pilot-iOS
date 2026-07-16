//
//  SuccessOTPCodeView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct SuccessOTPCodeView: View {
    var body: some View {
        ZStack {
            Color.darkBackGround.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                SuccessOTPScreen()
                SoundWaveView()
                Spacer()
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    SuccessOTPCodeView()
}
