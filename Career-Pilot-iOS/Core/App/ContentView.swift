//
//  ContentView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 12/07/2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var toastManager = ToastManager()
    @StateObject private var coordinator = AppCoordinator<AuthRoute>()
    @StateObject private var appState = AppState()
    
    var body: some View {
//        Group {
//            if appState.isLoggedIn {
//                MainTabBarView()
//            } else  {
//                NavigationStack(path: $coordinator.path) {
//
//                    if appState.isOnboadingSeen {
//
//                        PhoneEntryView()
//                            .navigationDestination(for: AuthRoute.self) { route in
//                                destination(for: route)
//                            }
//                    } else {
//                        OnBordingView(vm: DIContainer.shared.container.resolve(OnBordingViewModel.self)!)
//                            .navigationDestination(for: AuthRoute.self) { route in
//                                destination(for: route)
//                            }
//                    }
//                }
//            }
//        }
SettingsTabView()
        .environmentObject(coordinator)
        .environmentObject(appState)
        .environmentObject(ToastManager.shared)
        .toast(ToastManager.shared)
    }
    
    @MainActor
    @ViewBuilder
    private func destination(for route: AuthRoute) -> some View {
        switch route {
        case .phoneEntryScreen:
            PhoneEntryView()
        case .sendingOTPScreen(let phoneNumber):
            SendingOTPCodeView(phoneNumber: phoneNumber)
        case .otpScreen(let phoneNumber):
            if let authViewModel: AuthViewModel = DIContainer.shared.container.resolve(AuthViewModel.self) {
                        OTPView(phoneNumber: phoneNumber, viewModel: authViewModel)
                    } else {
                        Text("Error loading view model")
                    }
        case .successOTPScreen:
            SuccessOTPCodeView()
        case .onboardingScreen(let vm):
            OnBordingView(vm: vm)
        }
    }
}
