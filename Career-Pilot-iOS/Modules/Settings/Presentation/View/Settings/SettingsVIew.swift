import SwiftUI
import Shimmer

struct SettingView: View {
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject var appState: AppState
    @StateObject private var authCoordinator = AppCoordinator<AuthRoute>()
    var body: some View {
        ZStack {
            Color.gray100
                .ignoresSafeArea()
            
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
                            Text("Settings").font(.system(size: 22, weight: .bold)).foregroundColor(.primaryNavy)
                            ProfileCard(user: user)
                        }
                        Group {
                            Spacer().frame(height: Spacing.s12)
                            Text("ACCOUNT").font(.size14Semibold).foregroundColor(.gray400)
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
                        )
                        .onTapGesture {
                            Task {
                                try await viewModel
                                    .logout(appState: appState)
                                authCoordinator.popToRoot()
                            }
                        }
                    }
                    .padding(Spacing.s24)
                }
            }
        }
        .task {
            try? await viewModel.load()
        }
    }
    
    // MARK: - Shimmering skeleton, mirroring the real layout's shape
    private var settingsSkeleton: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.s12) {
                // "Settings" title placeholder
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray200)
                    .frame(width: 120, height: 26)
                
                // Profile card placeholder
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.gray200)
                        .frame(width: 56, height: 56)
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.gray200).frame(width: 140, height: 16)
                        RoundedRectangle(cornerRadius: 4).fill(Color.gray200).frame(width: 100, height: 12)
                    }
                    Spacer()
                }
                .padding(Spacing.s16)
                .background(RoundedRectangle(cornerRadius: Radius.r12).fill(Color.white))
                
                Spacer().frame(height: Spacing.s12)
                
                RoundedRectangle(cornerRadius: 4).fill(Color.gray200).frame(width: 80, height: 14)
                
                // Account rows placeholder
                VStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { index in
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: Radius.r12)
                                .fill(Color.gray200)
                                .frame(width: 44, height: 44)
                            VStack(alignment: .leading, spacing: 6) {
                                RoundedRectangle(cornerRadius: 4).fill(Color.gray200).frame(width: 100, height: 14)
                                RoundedRectangle(cornerRadius: 4).fill(Color.gray200).frame(width: 140, height: 12)
                            }
                            Spacer()
                        }
                        .padding(.vertical, Spacing.s8)
                        
                        if index != 2 {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, Spacing.s16)
                .background(RoundedRectangle(cornerRadius: Radius.r12).fill(Color.white))
                
                Spacer().frame(height: Spacing.s24)
                
                RoundedRectangle(cornerRadius: 4).fill(Color.gray200).frame(width: 140, height: 14)
                
                // Support & Legal rows placeholder
                VStack(spacing: 0) {
                    ForEach(0..<2, id: \.self) { index in
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: Radius.r12)
                                .fill(Color.gray200)
                                .frame(width: 44, height: 44)
                            RoundedRectangle(cornerRadius: 4).fill(Color.gray200).frame(width: 160, height: 14)
                            Spacer()
                        }
                        .padding(.vertical, Spacing.s8)
                        
                        if index != 1 {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, Spacing.s16)
                .background(RoundedRectangle(cornerRadius: Radius.r12).fill(Color.white))
            }
            .padding(Spacing.s24)
        }
        .redacted(reason: .placeholder)
        .shimmering()
    }
}
