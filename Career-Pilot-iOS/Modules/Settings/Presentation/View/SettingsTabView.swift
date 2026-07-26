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
                CheckOutView(checkoutItem: item)
            case .subscribtion:
                ChoosePlanView()
            case .coin:
                CoinView()
            }
        }}
//        ZStack {
//        Color.gray100
//                .ignoresSafeArea()
//        ScrollView{
//            VStack(alignment: .leading){
//                Group{
//                    Text("Settings").font(.size22Semibold).foregroundColor(.primaryNavy)
//                    ProfileCard()
//                }
//                Group{
//                    Spacer().frame(height: Spacing.s12)
//                    Text("ACCOUNT").font(.size14Semibold).foregroundColor(.gray400)
//                    Spacer().frame(height: Spacing.s6)
//                    AccountSettingsView()
//                    Spacer().frame(height: Spacing.s24)
//                    Text("Support & Legal").font(.size14Semibold).foregroundColor(.gray400)
//                    Spacer().frame(height: Spacing.s6)
//                    SupportAndLeagalSettingsView()
//                }
//
//                Spacer().frame(height: Spacing.s32)
//                Text("Danger Zone").font(.size14Semibold).foregroundColor(.gray400)
//                Spacer().frame(height: Spacing.s6)
//
//                HStack(spacing: 12) {
//                    Image(systemName: "trash.fill")
//                        .foregroundColor(.errorColour)
//                        .frame(width: 44, height: 44)
//                        .background(
//                            RoundedRectangle(cornerRadius: Radius.r20)
//                                .fill(Color.errorColour.opacity(0.08))
//                        )
//
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("Request Data Deletion")
//                            .font(.size14Medium)
//                            .foregroundColor(.errorColour)
//                        Text("Permanently delete account & data")
//                            .font(.caption)
//                            .foregroundColor(.gray400)
//                    }
//
//                    Spacer()
//
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.gray400)
//                        .font(.caption.bold())
//                }
//                .padding(.horizontal, Spacing.s20)
//                .padding(.vertical, Spacing.s8)
//                .background(
//                    RoundedRectangle(cornerRadius: Radius.r12)
//                        .fill(Color.white)
//                )
//
//                Spacer().frame(height: Spacing.s12)
//
//
//                HStack {
//                    Spacer()
//                    HStack(spacing: 8) {
//                        Image(systemName: "rectangle.portrait.and.arrow.right")
//                            .foregroundColor(.errorColour)
//                        Text("Sign Out")
//                            .font(.size14Medium)
//                            .foregroundColor(.errorColour)
//                    }
//                    Spacer()
//                }
//                .padding(.vertical, Spacing.s12)
//                .background(
//                    RoundedRectangle(cornerRadius: Radius.r12)
//                        .fill(Color.errorColour.opacity(0.08))
//                )
//
//
//            }
//            .padding(Spacing.s24)
//        }
//
//    }
  
//
//struct SettingsVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
