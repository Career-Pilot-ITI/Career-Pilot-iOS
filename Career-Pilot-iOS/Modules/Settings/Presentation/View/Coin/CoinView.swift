//
//  CoinView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct CoinView: View {
    @StateObject var viewModel: CoinViewModel = CoinViewModel(getCoinPacksUseCase: GetCoinsPlans(settingsRepo: DIContainer.shared.container.resolve(SettingsRepoImp.self)!))
    
    var body: some View {
        VStack(spacing : 0 ){
            CoinTopView()
            Spacer().frame(height: Spacing.s20)
            CoinsValueView(viewModel: viewModel)
            
        }
        .navigationTitle("Coins")
        .toolbar(.hidden, for: .tabBar)
        .padding(.horizontal , Spacing.s20)
        .background(Color.background.ignoresSafeArea())

    }
}

//struct CoinView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoinView(viewModel: CoinViewModel(getCoinPacksUseCase: GetCoinsPlans(settingsRepo: SettingsRepoImp(remote: SettingsRemoteImp(apiService:URLSessionNetworkService() ), local: SettingsLocalDataSourceImp(coreDataManager: CoreDataManager()), authToken: <#AuthTokenStoring#>))))
//    }
//}
