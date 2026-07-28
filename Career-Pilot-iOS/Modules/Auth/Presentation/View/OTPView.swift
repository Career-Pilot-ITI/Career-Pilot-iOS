//
//  OTPView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//
import SwiftUI

struct OTPView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var coordinator: AppCoordinator<AuthRoute>
    @EnvironmentObject var toastManager: ToastManager
    @StateObject private var viewModel: AuthViewModel
    @State private var code: String
    @State private var showBackConfirmation = false
    private let phoneNumber: String

    init(
        phoneNumber: String,
        code: String = "",
       
        viewModel: @autoclosure @escaping () -> AuthViewModel
    ) {
        self.phoneNumber = phoneNumber
        self._code = State(initialValue: code)
        self._viewModel = StateObject(wrappedValue: viewModel())
        print(phoneNumber)
    }

    var body: some View {
        ZStack {
            Color.darkBackGround.ignoresSafeArea()

            VStack(alignment: .leading) {
                Text("Enter your code")
                    .foregroundStyle(.white)
                    .font(.size26Semibold)
                    .padding(.bottom, 8)
                HStack {
                    Text("Sent to")
                        .foregroundStyle(.white)
                        .font(.size14Regular)
                    Text(phoneNumber)
                        .foregroundStyle(.white)
                        .font(.size14Regular)
                }
                .padding(.bottom, 36)

                ZStack {
                    OTPCodeView(
                        code: $code,
                        phoneNumber: phoneNumber
                    ) { _ in
                        verifyEnteredCode()
                    } onResend: {
                        Task { await viewModel.sendOTP(for: phoneNumber) }
                    }
                    .disabled(viewModel.isLoading)
                    .lampGlitch(isActive: viewModel.isLoading)
                    .opacity(viewModel.isLoading ? 0.35 : 1)
 
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)

                Spacer()
            }
            .padding(.top, 32)
            .padding(.horizontal, Spacing.s24)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showBackConfirmation = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Change number")
                    }
                    .font(.size14Regular)
                    .foregroundColor(.white)
                }
            }
        }
        .alert("Change Phone Number?", isPresented: $showBackConfirmation) {
            Button("Go Back", role: .destructive) {
                code = ""
                coordinator.popToRoot()
            }
            Button("Stay", role: .cancel) { }
        } message: {
            Text("You'll need to request a new code if you change your number.")
        }
    }

    private func verifyEnteredCode() {
        Task {
            let input = VerifyOTPInput(phoneNumber: phoneNumber, code: code)
            guard let result = await viewModel.verifyOTP(input) else {
                code = ""
                return
            }
            
            appState.markLoggedIn()
            
            if !result.user.isNewUser {
                // Returning user — skip onboarding
                appState.markOnboardingSeen()
            }
            
            coordinator.push(.successOTPScreen)
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(
            phoneNumber: "+20 101 234 5678",
            viewModel: DIContainer.shared.container.resolve(AuthViewModel.self)!
        )
        .environmentObject(AppCoordinator<AuthRoute>())
    }
}

