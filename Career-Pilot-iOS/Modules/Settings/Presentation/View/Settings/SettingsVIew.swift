import SwiftUI
import Shimmer

struct SettingView: View {
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject var appState: AppState
    @StateObject private var authCoordinator = AppCoordinator<AuthRoute>()

    var body: some View {
        ZStack {
            content
        }
        .background(Color.background.ignoresSafeArea())
        .task {
            await viewModel.load()
        }
    }

    // MARK: - Top level switch, pulled out of `body`
    @ViewBuilder
    private var content: some View {
        switch viewModel.loadState {
        case .loading, .idle:
            settingsSkeleton

        case .failure(let error):
            errorView(error)

        case .success(let user):
            successView(user)
        }
    }

    // MARK: - Error State
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.errorColour)
            Text("There is an error")
                .font(.size16Bold)
                .foregroundColor(.primary)
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.gray400)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Success State
    private func successView(_ user: UserModelSettingsView) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                headerSection(user)
                accountPreferencesSupportSection(user)
                dangerZoneSection
                Spacer().frame(height: Spacing.s12)
                signOutButton
            }
            .padding(Spacing.s24)
        }
    }

    private func headerSection(_ user: UserModelSettingsView) -> some View {
        Group {
            Text("Settings")
                .font(.system(size: 22, weight: .bold))
            ProfileCard(user: user)
        }
    }

    private func accountPreferencesSupportSection(_ user: UserModelSettingsView) -> some View {
        Group {
            Spacer().frame(height: Spacing.s12)
            Text("Account").font(.size14Semibold).foregroundColor(.gray400)
            Spacer().frame(height: Spacing.s6)
            AccountSettingsView(user: user)

            Spacer().frame(height: Spacing.s24)
            Text("Preferences").font(.size14Semibold).foregroundColor(.gray400)
            Spacer().frame(height: Spacing.s6)
            ThemeToggleRow()
            Group{
                Spacer().frame(height: Spacing.s24)
                Text("Support & Legal").font(.size14Semibold).foregroundColor(.gray400)
                Spacer().frame(height: Spacing.s6)
                SupportAndLeagalSettingsView()
            }
       
        }
       
    }

    private var dangerZoneSection: some View {
        Group {
            Spacer().frame(height: Spacing.s32)
            Text("Danger Zone").font(.size14Semibold).foregroundColor(.gray400)
            Spacer().frame(height: Spacing.s6)
            dangerZoneRow
        }
    }

    private var dangerZoneRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "shield.slash.fill")
                .font(.system(size: 18, weight: .semibold))
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
                .fill(Color.gray400.opacity(0.08))
        )
    }

    private var signOutButton: some View {
        HStack {
            Spacer()
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .semibold))
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
                .fill(Color.errorColour.opacity(0.2))
        )
        .onTapGesture {
            Task {
                await viewModel.logout(appState: appState)
                authCoordinator.popToRoot()
            }
        }
    }

    // MARK: - Settings Skeleton View
    private var settingsSkeleton: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.s12) {

                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(width: 120, height: 26)

                skeletonProfileRow

                Spacer().frame(height: Spacing.s12)

                // Section Title Placeholder
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 14)

                skeletonAccountRows

                Spacer().frame(height: Spacing.s24)

                // Section Title Placeholder
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(width: 140, height: 14)

                skeletonSupportRows
            }
            .padding(Spacing.s24)
        }
        .shimmering()
    }

    private var skeletonProfileRow: some View {
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
    }

    private var skeletonAccountRows: some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { index in
                skeletonRow(showTrailingSubtitle: true)
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
    }

    private var skeletonSupportRows: some View {
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

    private func skeletonRow(showTrailingSubtitle: Bool) -> some View {
        HStack(spacing: Spacing.s16) {
            RoundedRectangle(cornerRadius: Radius.r14)
                .fill(Color(.systemGray5))
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: Spacing.s8) {
                RoundedRectangle(cornerRadius: Radius.r6)
                    .fill(Color(.systemGray5))
                    .frame(width: 100, height: 14)

                if showTrailingSubtitle {
                    RoundedRectangle(cornerRadius: Radius.r6)
                        .fill(Color(.systemGray5))
                        .frame(width: 140, height: 12)
                }
            }
            Spacer()
        }
    }
}

// MARK: - Theme Toggle Row Component (XIX Styled)
struct ThemeToggleRow: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            iconBadge

            VStack(alignment: .leading, spacing: 2) {
                Text("Dark Mode")
                    .font(.size14Medium)
                    .foregroundColor(.primary)

                Text(isDarkMode ? "Enabled" : "Disabled")
                    .font(.caption)
                    .foregroundColor(.gray400)
            }

            Spacer()

            Toggle("", isOn: $isDarkMode)
                .labelsHidden()
                .tint(.accentColor)
        }
        .padding(Spacing.s16)
        .background(Color.background)
        .cornerRadius(Radius.r16)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.r16)
                .stroke(Color(.systemGray6), lineWidth: 1)
        )
    }

    private var iconBadge: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radius.r14)
                .fill(isDarkMode ? Color.indigo.opacity(0.18) : Color.orange.opacity(0.18))
                .frame(width: 44, height: 44)

            Image(systemName: isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isDarkMode ? .indigo : .orange)
        }
    }
}
