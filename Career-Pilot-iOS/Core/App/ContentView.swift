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
            if let authViewModel: AuthViewModel = DIContainer.shared.container.resolve(AuthViewModel.self) {
                        OTPView(phoneNumber: phoneNumber, viewModel: authViewModel)
                    } else {
                        Text("Error loading view model")
                    }
        case .successOTPScreen:
            SuccessOTPCodeView()
        case .onboardingScreen(let vm):
            OnBordingView(vm: vm)
            case .checkout(let item ):
                CheckOutView(checkoutItem: item)
            case .subscribtion :
                ChoosePlanView()
        }
    }
    
}
