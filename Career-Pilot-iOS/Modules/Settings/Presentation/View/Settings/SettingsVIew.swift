//
//  SettingsVIew.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct SettingView: View {
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject var appState: AppState
    var body: some View {
        ZStack {
            Color.gray100
                .ignoresSafeArea()
            
            switch viewModel.loadState {
            case .loading , .idle :
                ProgressView()
                    .scaleEffect(1.5)
            case .failure(let error):
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.errorColour)
                    Text("There is an error")
                        .font(.size16Bold)
                        .foregroundColor(.primaryNavy)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.gray400)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .success(let user):
                ScrollView {
                    VStack(alignment: .leading) {
                        Group{
                            Text("Settings").font(.system(size: 22 , weight: .bold)).foregroundColor(.primaryNavy)
                            
                            ProfileCard(user: user)
                        }
                        Group{
                            Spacer().frame(height: Spacing.s12)
                            Text("ACCOUNT").font(.size14Semibold).foregroundColor(.gray400)
                            Spacer().frame(height: Spacing.s6)
                            AccountSettingsView(user: user)
                            Spacer().frame(height: Spacing.s24)
                            Text("Support & Legal").font(.size14Semibold).foregroundColor(.gray400)
                            Spacer().frame(height: Spacing.s6)
                            SupportAndLeagalSettingsView()
                        }
                        
                        Group{
                            Spacer().frame(height: Spacing.s32)
                            Text("Danger Zone").font(.size14Semibold).foregroundColor(.gray400)
                            Spacer().frame(height: Spacing.s6)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.errorColour)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: Radius.r20)
                                            .fill(Color.errorColour.opacity(0.08))
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Request Data Deletion")
                                        .font(.size14Medium)
                                        .foregroundColor(.errorColour)
                                    Text("Permanently delete account & data")
                                        .font(.caption)
                                        .foregroundColor(.gray400)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray400)
                                    .font(.caption.bold())
                            }
                            .padding(.horizontal, Spacing.s20)
                            .padding(.vertical, Spacing.s8)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.r12)
                                    .fill(Color.white)
                            )
                        }
                        
                        Spacer().frame(height: Spacing.s12)
                        
                        HStack {
                            Spacer()
                            HStack(spacing: 8) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.errorColour)
                                Text("Sign Out")
                                    .font(.size14Medium)
                                    .foregroundColor(.errorColour)
                            }
                            Spacer()
                        }
                        .padding(.vertical, Spacing.s12)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.r12)
                                .fill(Color.errorColour.opacity(0.08))
                        ).onTapGesture {
                            Task{
                                try await viewModel.logout(appState: appState)
                                
                        
                            }
                            
                        }
                    }
                    .padding(Spacing.s24)
                }
       
                
            }
        }
        .task {
            // Automatically fetch data when the view appears, ignoring errors since they are caught in VM
            try? await viewModel.load()
        }
    }
}

//struct SettingsVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsVIew()
//    }
//}
