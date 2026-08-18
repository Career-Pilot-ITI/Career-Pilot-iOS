//
//  PhoneEntryView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct PhoneEntryView: View {
    @EnvironmentObject var coordinator: AppCoordinator<AuthRoute>
    @EnvironmentObject var toastManager: ToastManager
    @StateObject private var phoneFieldViewModel = PhoneFieldViewModel()

       
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            GeometryReader { geo in
                VStack() {
                    Spacer()
                    SoundWaveView(
                        barCount: 24,
                        maxHeight: 144
                    )
                    .opacity(0.16)
                    Spacer(minLength: geo.size.height * 0.74)
                    SoundWaveView(
                        barCount: 24,
                        color: Color.primary,
                        maxHeight: 26
                    )
                    .opacity(0.4)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            
            VStack(alignment: .leading) {
                HStack(spacing:16) {
                    Image(systemName: "mic")
                        .font(.system(size: 18,weight: .bold))
                        .foregroundColor(.white)
                        .background {
                            RoundedRectangle(cornerRadius: Radius.r14)
                                .fill(Color.primary)
                                .frame(width: 36, height: 36)
                                
                        }
                    
                    Text("CareerPilot")
                        .font(.size18Bold)
                }
                .padding(.top,24)
                .padding(.bottom,40)
                
                VStack(alignment: .leading,spacing: Spacing.s8) {
                    Text("Your AI Interview Coach Awaits")
                        .font(.size32Bold)
                    
                    Text("Practice realistic interviews, get instant feedback, and land your dream role.")
                        .font(.size14Regular)
                        .foregroundColor(Color.gray600)
                }
                .padding(.bottom,36)
                
                VStack() {
                    PhoneTextField(viewModel: phoneFieldViewModel)
                        .padding(.bottom, 16)
                    
                    
                    CustomButton(showArrow: true, buttonTitle: "Continue") {
                        guard phoneFieldViewModel.canProceed else {
                            phoneFieldViewModel.markAsEditedIfNeeded()
                            return
                        }

                        let phoneNumber = phoneFieldViewModel.rawPhoneNumber()
                        coordinator.push(
                            .sendingOTPScreen(
                                phoneNumber:phoneNumber.removingLeadingPlus()
                            )
                        )
                    }
                    .disabled(!phoneFieldViewModel.canProceed)
                    .opacity(phoneFieldViewModel.canProceed ? 1 : 0.5)
                    .padding(.bottom, 20)
                    
                    HStack(spacing:2) {
                        Text("By continuing you agree to our")
                            .font(.size12Regular)
                            .foregroundColor(Color.gray600)
                        
                        Text("Terms of Service")
                            .font(.size12Regular)
                            .foregroundColor(Color.primary)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, Spacing.s24)
        }
    }
}
//#Preview {
//    PhoneEntryView()
//}
