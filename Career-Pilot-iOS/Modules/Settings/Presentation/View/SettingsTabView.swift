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
            SettingView(viewModel: SettingsViewModel(getUserData: GetUserDataUseCase(settingsRepo: SettingsRepoImp(remote: SettingsRemoteImp(apiService: URLSessionNetworkService()), local:SettingsLocalDataSourceImp(coreDataManager: CoreDataManager()), authToken: KeychainAuthTokenStore() )), userLogout: LogoutUsecase(settingsRepo: SettingsRepoImp(remote: SettingsRemoteImp(apiService: URLSessionNetworkService()), local:SettingsLocalDataSourceImp(coreDataManager: CoreDataManager()), authToken: KeychainAuthTokenStore() )))).environmentObject(settingsCoordinator)
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
                CheckOutView(checkoutDisplayInfo: item, paymentVM: PaymentViewModel(verifyPaymentUseCase: VerifyPaymentUseCaseImp(getUserData: GetUserDataUseCase(settingsRepo: SettingsRepoImp(remote: SettingsRemoteImp(apiService: URLSessionNetworkService()), local: SettingsLocalDataSourceImp(coreDataManager: CoreDataManager()), authToken: KeychainAuthTokenStore())), checkoutRepo: CheckoutRepoImplementation(remote: CheckoutRemoteDataSourceImp(checkOutNetworkService:URLSessionNetworkService() ))), checkoutUsecase: CheckoutUsecase(checkoutRepo: CheckoutRepoImplementation(remote: CheckoutRemoteDataSourceImp(checkOutNetworkService: URLSessionNetworkService()))), userRefreshData: RefreshUserDataUseCase(settingsRepo:SettingsRepoImp(remote: SettingsRemoteImp(apiService: URLSessionNetworkService()), local: SettingsLocalDataSourceImp(coreDataManager: CoreDataManager()), authToken: KeychainAuthTokenStore()) )))
            case .subscribtion:
                ChoosePlanView()
            case .coin:
                CoinView()
            }
        }}
