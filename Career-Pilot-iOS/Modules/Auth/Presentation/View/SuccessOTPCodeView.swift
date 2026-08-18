//
//  SuccessOTPCodeView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct SuccessOTPCodeView: View {
    @EnvironmentObject var coordinator: AppCoordinator<AuthRoute>

    @State private var navigationTask: Task<Void, Never>?
    
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
        .navigationBarBackButtonHidden(true)
        .onAppear {
            navigationTask = Task {
                try? await Task.sleep(for: .seconds(5))
                guard !Task.isCancelled else { return }
                // Only new users reach this screen; always proceed to onboarding.
                coordinator.push(.onboardingScreen(vm: DIContainer.shared.container.resolve(OnBordingViewModel.self)!))
            }
        }
        .onDisappear {
            navigationTask?.cancel()
        }
    }
}
//
//#Preview {
//    SuccessOTPCodeView()
//}
