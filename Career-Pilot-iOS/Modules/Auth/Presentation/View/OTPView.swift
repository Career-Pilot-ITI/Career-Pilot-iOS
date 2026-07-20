//
//  OTPView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//
import SwiftUI

struct OTPView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var toastManager: ToastManager
    @StateObject private var viewModel: AuthViewModel
    @State private var code: String
    private let phoneNumber: String

    init(
        phoneNumber: String,
        code: String = "",
        viewModel: @autoclosure @escaping () -> AuthViewModel
    ) {
        self.phoneNumber = phoneNumber
        self._code = State(initialValue: code)
        self._viewModel = StateObject(wrappedValue: viewModel())
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
    }

    private func verifyEnteredCode() {
        Task {
            let input = VerifyOTPInput(phoneNumber: phoneNumber, code: code)
            let success = await viewModel.verifyOTP(input)
            if success {
                coordinator.push(.successOTPScreen)
            } else {
                code = ""
            }
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(
            phoneNumber: "+20 101 234 5678",
            viewModel: DIContainer.shared.container.resolve(AuthViewModel.self)!
        )
        .environmentObject(AppCoordinator())
    }
}
