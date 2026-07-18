//
//  SendingOTPCodeView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct SendingOTPCodeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var authViewModel = AuthViewModel(
        sendUseCase: SendOTPUseCase(repository: AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSource())),
        verifyUseCase: VerifyOTPUseCase(repository: AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSource())),
        toastManager: .shared
    )
    let phoneNumber: String
    @State private var sendOTPTask: Task<Void, Never>?

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
        .navigationBarBackButtonHidden(true)
        .onAppear {
            sendOTPTask = Task {
                let success = await authViewModel.sendOTP(for: phoneNumber)
                guard !Task.isCancelled else { return }
                if success {
                    coordinator.push(.otpScreen(phoneNumber: phoneNumber))
                } else {
                    try? await Task.sleep(for: .seconds(1.5))
                    guard !Task.isCancelled else { return }
                    coordinator.pop()
                }
            }
        }
        .onDisappear {
            sendOTPTask?.cancel()
        }
        
    }
}

struct SendingOTPCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SendingOTPCodeView(phoneNumber: "+201012345678")
            .environmentObject(AppCoordinator())
    }
}
