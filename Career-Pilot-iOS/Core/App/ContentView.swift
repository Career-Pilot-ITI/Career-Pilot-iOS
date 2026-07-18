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
    @StateObject private var coordiantor = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordiantor.path) {
            PhoneEntryView()
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for:route)
                }
        }
        .environmentObject(coordiantor)
        .environmentObject(ToastManager.shared)
        .toast(ToastManager.shared)
    }
    
    @ViewBuilder
        private func destination(for route: AppRoute) -> some View {
            switch route {
            case .phoneEntryScreen:
                PhoneEntryView()
            case .sendingOTPScreen(let phoneNumber):
                SendingOTPCodeView(phoneNumber: phoneNumber)
            case .otpScreen(let phoneNumber):
                OTPView(
                        phoneNumber: phoneNumber,
                        viewModel: AuthViewModel(
                            sendUseCase: SendOTPUseCase(repository: AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSource())),
                            verifyUseCase: VerifyOTPUseCase(repository: AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSource())),
                            toastManager: .shared
                        )
                    )
            case .successOTPScreen:
                SuccessOTPCodeView()
            case .onboardingScreen(let vm):
                OnBordingView(vm: vm)
            }
        }
    
}
