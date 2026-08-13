//
//  SettingsVIew.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct SettingsTabView: View {
    @StateObject private var settingsCoordinator = AppCoordinator<SettingsRoute>()
    var body: some View {
        NavigationStack(path: $settingsCoordinator.path) {
            SettingView(viewModel:DIContainer.shared.container.resolve(SettingsViewModel.self)!).environmentObject(settingsCoordinator)
                .navigationDestination(for: SettingsRoute.self) { route in
                    settingsDestination(for: route).environmentObject(settingsCoordinator)
                }
            
            
                
        }.environmentObject(settingsCoordinator)
        
    }
        
        @MainActor
        @ViewBuilder
        private func settingsDestination(for route: SettingsRoute) -> some View {
            switch route {
            case .checkout(let item):
                CheckOutView(checkoutDisplayInfo: item, paymentVM: DIContainer.shared.container.resolve(PaymentViewModel.self)!)
            case .subscribtion:
                ChoosePlanView(viewModel: DIContainer.shared.container.resolve(SubscriptionViewModel.self)!)
            case .coin:
                CoinView()
            case .profileSettings :
                ProfileScreen(viewModel: DIContainer.shared.container.resolve(ProfileViewModel.self)!)
            }
        }}
