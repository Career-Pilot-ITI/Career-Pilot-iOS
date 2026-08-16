//
//  ProfileScreen.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/07/2026.
//

import SwiftUI
import Shimmer

struct ProfileScreen: View {
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var toastManager: ToastManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            switch viewModel.load {
            case .idle, .loading:
                profileSkeleton
                
            case .failure(let error):
                if let editableUser = Binding($viewModel.editableUser) {
                    errorState(error, user: editableUser)
                }
            case .success:
                if let editableUser = Binding($viewModel.editableUser) {
                    successContent(editableUser)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.background)
        .navigationBarBackButtonHidden(viewModel.load == .loading || viewModel.load == .idle)
        .task {
            await viewModel.loadAllScreenData()
        }
        .onChange(of: viewModel.load) { newState in
            guard case .failure(let error) = newState else { return }
            
            if let validationError = error as? ProfileValidationError {
                toastManager.show(validationError.errorDescription ?? "Please check your details", type: .error)
            } else {
                toastManager.show("Couldn't load your profile", type: .error)
            }
        }
    }
    
    @ViewBuilder
    private func successContent(_ user: Binding<UserModelSettingsView>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Header with Back Button and Save Action
            HStack(spacing: Spacing.s12) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primaryNavy)
                }
                
                SettingsProfileTopView(
                    isSaveEnabled: viewModel.hasChanges,
                    onSave: {
                        Task {
                            await viewModel.updateUserData()
                        }
                    }
                )
            }
            
            Spacer()
                .foregroundColor(.gray400)
                .frame(height: Spacing.s8)
            
            Group {
                ProfileFormSettings(user: user, tracks: viewModel.tracks ?? []) { data in
                    viewModel.avatarPicked(imageData: data)
                }
                Spacer().frame(height: Spacing.s16)
            }
            
            Group {
                Text("CV/ Resume").font(.size14Semibold).foregroundColor(.gray400)
                Spacer().frame(height: Spacing.s16)
                CvResumeSettingsProfile(cv: user.wrappedValue.cvUrl?.absoluteString ?? "") { url in
                    Task {
                        await viewModel.cvPicked(url: url)
                    }
                }
                Spacer().frame(height: Spacing.s16)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("SKILLS DETECTED")
                    .font(.size14Semibold)
                    .foregroundColor(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: Spacing.s16)
                
                SkillsDetectedSettingsProfile(skills: user.wrappedValue.skills.map { $0.skillName })
            }
        }
        .padding(.horizontal, Spacing.s16)
    }
    
    @ViewBuilder
    private func errorState(_ error: Error, user: Binding<UserModelSettingsView>) -> some View {
        if error is ProfileValidationError {
            successContent(user)
        } else {
            VStack(alignment: .leading, spacing: Spacing.s16) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                genericErrorContent(
                    icon: "exclamationmark.triangle.fill",
                    iconColor: .errorColour,
                    title: "Couldn't load your profile",
                    message: error.localizedDescription
                )
            }
            .padding(.horizontal, Spacing.s16)
        }
    }
    
    private func genericErrorContent(icon: String, iconColor: Color, title: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(iconColor)
            Text(title)
                .font(.size16Bold)
                .foregroundColor(.primaryNavy)
            Text(message)
                .font(.caption)
                .foregroundColor(.gray400)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again") {
                Task { await viewModel.loadAllScreenData() }
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 400)
    }
    
    // MARK: - Profile Skeleton
    private var profileSkeleton: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray4))
                    .frame(width: 100, height: 18)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 50, height: 18)
            }
            
            VStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: Radius.r12)
                            .fill(Color(.systemGray5))
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray4))
                                .frame(width: 70, height: 12)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(width: [140.0, 170.0, 110.0, 150.0][index], height: 14)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    
                    if index != 3 {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
            }
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: Radius.r12)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: 100, height: 14)
            
            RoundedRectangle(cornerRadius: Radius.r12)
                .fill(Color(.secondarySystemGroupedBackground))
                .frame(height: 72)
        }
        .padding(.horizontal, Spacing.s16)
        .shimmering()
    }
}
