//
//  SendingOTPCodeView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct SendingOTPCodeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    let phoneNumber: String
    @State private var navigationTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            Color.darkBackGround.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                CallingWaitingScreen(phoneNumber: phoneNumber)
                SoundWaveView()
                Spacer()
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            navigationTask = Task  {
                try? await Task.sleep(for: .seconds(5))
                guard !Task.isCancelled else { return }
                coordinator.push(.otpScreen)
            }
        }
        .onDisappear {
                    navigationTask?.cancel()
        }
    }
}

struct SendingOTPCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SendingOTPCodeView(phoneNumber: "+201012345678")
            .environmentObject(AppCoordinator())
    }
}
