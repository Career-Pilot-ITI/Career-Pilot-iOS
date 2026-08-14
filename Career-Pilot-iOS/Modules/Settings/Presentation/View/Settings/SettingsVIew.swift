import SwiftUI
import Shimmer

struct SettingView: View {
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject var appState: AppState
    @StateObject private var authCoordinator = AppCoordinator<AuthRoute>()
    
    var body: some View {
        ZStack {
            switch viewModel.loadState {
            case .loading, .idle:
                settingsSkeleton
                
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
                        Group {
                            Text("Settings")
                                .font(.system(size: 22, weight: .bold))
                            ProfileCard(user: user)
                        }
                        Group {
                            Spacer().frame(height: Spacing.s12)
                            Text("Account").font(.size14Semibold).foregroundColor(.gray400)
                            Spacer().frame(height: Spacing.s6)
                            AccountSettingsView(user: user)
                            Spacer().frame(height: Spacing.s24)
                            Text("Support & Legal").font(.size14Semibold).foregroundColor(.gray400)
                            Spacer().frame(height: Spacing.s6)
                            SupportAndLeagalSettingsView()
                        }
                        
                        Group {
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
                                    .fill(Color.gray400.opacity(0.08))
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
                                .fill(Color.errorColour.opacity(0.3))
                        )
                        .onTapGesture {
                            Task {
                                await viewModel.logout(appState: appState)
                                authCoordinator.popToRoot()
                            }
                        }
                    }
                    .padding(Spacing.s24)
                }
            }
        }
        .background(Color(.background).ignoresSafeArea())
        .task {
           await viewModel.load()
        }
    }
    
    // MARK: - Settings Skeleton View
    private var settingsSkeleton: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.s12) {
                
                // "Settings" title placeholder
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(width: 120, height: 26)
                
                // Profile card placeholder
                HStack(spacing: Spacing.s16) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 56, height: 56)
                    
                    VStack(alignment: .leading, spacing: Spacing.s8) {
                        RoundedRectangle(cornerRadius: Radius.r6)
                            .fill(Color(.systemGray5))
                            .frame(width: 140, height: 16)
                        
                        RoundedRectangle(cornerRadius: Radius.r6)
                            .fill(Color(.systemGray5))
                            .frame(width: 100, height: 12)
                    }
                    Spacer()
                }
                .padding(Spacing.s16)
                .background(Color.background)
                .cornerRadius(Radius.r16)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.r16)
                        .stroke(Color(.systemGray6), lineWidth: 1)
                )
                
                Spacer().frame(height: Spacing.s12)
                
                // Section Title Placeholder
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 14)
                
                // Account rows placeholder
                VStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { index in
                        HStack(spacing: Spacing.s16) {
                            RoundedRectangle(cornerRadius: Radius.r14)
                                .fill(Color(.systemGray5))
                                .frame(width: 44, height: 44)
                            
                            VStack(alignment: .leading, spacing: Spacing.s8) {
                                RoundedRectangle(cornerRadius: Radius.r6)
                                    .fill(Color(.systemGray5))
                                    .frame(width: 100, height: 14)
                                
                                RoundedRectangle(cornerRadius: Radius.r6)
                                    .fill(Color(.systemGray5))
                                    .frame(width: 140, height: 12)
                            }
                            Spacer()
                        }
                        .padding(.vertical, Spacing.s8)
                        
                        if index != 2 {
                            Divider()
                        }
                    }
                }
                .padding(Spacing.s16)
                .background(Color.background)
                .cornerRadius(Radius.r16)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.r16)
                        .stroke(Color(.systemGray6), lineWidth: 1)
                )
                
                Spacer().frame(height: Spacing.s24)
                
                // Section Title Placeholder
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(width: 140, height: 14)
                
                // Support & Legal rows placeholder
                VStack(spacing: 0) {
                    ForEach(0..<2, id: \.self) { index in
                        HStack(spacing: Spacing.s16) {
                            RoundedRectangle(cornerRadius: Radius.r14)
                                .fill(Color(.systemGray5))
                                .frame(width: 44, height: 44)
                            
                            RoundedRectangle(cornerRadius: Radius.r6)
                                .fill(Color(.systemGray5))
                                .frame(width: 160, height: 14)
                            
                            Spacer()
                        }
                        .padding(.vertical, Spacing.s8)
                        
                        if index != 1 {
                            Divider()
                        }
                    }
                }
                .padding(Spacing.s16)
                .background(Color.background)
                .cornerRadius(Radius.r16)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.r16)
                        .stroke(Color(.systemGray6), lineWidth: 1)
                )
            }
            .padding(Spacing.s24)
        }
        .shimmering()
    }
}
