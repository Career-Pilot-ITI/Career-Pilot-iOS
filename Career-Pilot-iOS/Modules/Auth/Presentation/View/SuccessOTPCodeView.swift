//
//  SuccessOTPCodeView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct SuccessOTPCodeView: View {
    @EnvironmentObject var coordinator: AppCoordinator<AuthRoute>
    @EnvironmentObject var appState: AppState
    
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
            navigationTask = Task  {
                try? await Task.sleep(for: .seconds(5))
                guard !Task.isCancelled else { return }
                
                if appState.isOnboadingSeen {
                    // Returning user — ContentView will automatically show MainTabBarView
                    // since isOnboadingSeen is already true. Just pop back so the
                    // NavigationStack is clean when ContentView swaps its root.
                    coordinator.popToRoot()
                } else {
                    // New user — proceed to onboarding
                    coordinator.push(.onboardingScreen(vm: DIContainer.shared.container.resolve(OnBordingViewModel.self)!))
                }
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
