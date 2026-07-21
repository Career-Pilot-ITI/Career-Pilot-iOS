//
//  PhoneEntryView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct PhoneEntryView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            Color.darkBackGround.ignoresSafeArea()
            
            GeometryReader { geo in
                VStack() {
                    Spacer()
                    SoundWaveView(
                        barCount: 24,
                        maxHeight: 144
                    )
                    .opacity(0.15)
                    Spacer(minLength: geo.size.height * 0.74)
                    SoundWaveView(
                        barCount: 24,
                        color: Color.activeColour,
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
                                .fill(Color.activeColour)
                                .frame(width: 36, height: 36)
                                
                        }
                    
                    Text("CareerPilot")
                        .font(Font.cardTitleBold)
                        .foregroundColor(.white)
                }
                .padding(.top,24)
                .padding(.bottom,40)
                
                VStack(alignment: .leading,spacing: Spacing.s8) {
                    Text("Your AI Interview Coach Awaits")
                        .font(Font.screenTitleBold)
                        .foregroundColor(.white)
                    
                    Text("Practice realistic interviews, get instant feedback, and land your dream role.")
                        .font(Font.bodyAppRegular)
                        .foregroundColor(Color.gray400)
                }
                .padding(.bottom,36)
                
                VStack() {
                    PhoneTextField(viewModel: PhoneFieldViewModel(selectedCountry: CountryCode.defaultList[0]))
                        .padding(.bottom, 16)
                    
                    
                    CustomButton(showArrow: true, buttonTitle: "Continue") {
                        // handle navigation here after user enters phone number
                        coordinator.push(.sendingOTPScreen)
                    }
                    .padding(.bottom, 20)
                    
                    HStack(spacing:2) {
                        Text("By continuing you agree to our")
                            .font(Font.labelAppRegular)
                            .foregroundColor(Color.gray600)
                        
                        Text("Terms of Service")
                            .font(Font.labelAppRegular)
                            .foregroundColor(Color.activeColour)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, Spacing.s24)
        }
    }
}
#Preview {
    PhoneEntryView()
}
