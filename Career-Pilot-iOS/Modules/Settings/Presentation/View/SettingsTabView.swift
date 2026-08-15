//
//  SettingsVIew.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct SettingsTabView: View {
    @StateObject private var settingsCoordinator = AppCoordinator<SettingsRoute>()
    @Binding var deepLink: SettingsRoute?
    var body: some View {
        NavigationStack(path: $settingsCoordinator.path) {
            SettingView(viewModel:DIContainer.shared.container.resolve(SettingsViewModel.self)!).environmentObject(settingsCoordinator)
                .navigationDestination(for: SettingsRoute.self) { route in
                    settingsDestination(for: route).environmentObject(settingsCoordinator)
                }
            
            
                
        }
        .environmentObject(settingsCoordinator)
        .onAppear(perform: openDeepLinkIfNeeded)
        .onChange(of: deepLink) { _ in openDeepLinkIfNeeded() }
        
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
            case .profile :
                ProfileScreen(viewModel: DIContainer.shared.container.resolve(ProfileViewModel.self)!)
            }
        }}

private extension SettingsTabView {
    func openDeepLinkIfNeeded() {
        guard let deepLink else { return }
        settingsCoordinator.push(deepLink)
        self.deepLink = nil
    }
}
