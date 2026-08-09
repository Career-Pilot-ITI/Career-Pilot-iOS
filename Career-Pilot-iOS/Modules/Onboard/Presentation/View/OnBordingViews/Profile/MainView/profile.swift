//
//  profile.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct profile: View {
    @ObservedObject var vm: OnBordingViewModel
    @EnvironmentObject var toastManager: ToastManager

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HeaderView()

                ProfileForm(userData: $vm.userData)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.r12)
                            .fill(Color.white)
                    )
                    .shadow(
                        color: Color.black.opacity(0.08),
                        radius: 12,
                        x: 0,
                        y: 4
                    )

                FreeSessionBanner()
            }
            .padding(.horizontal, Spacing.s20)
        }
        .scrollIndicators(.hidden)
        .background(Color.gray100)
        .ignoresSafeArea(.keyboard)
        .onChange(of: vm.screenState) { newState in
            guard case .error(let message) = newState else { return }
            toastManager.show(message, type: .error)
        }
    }
}
