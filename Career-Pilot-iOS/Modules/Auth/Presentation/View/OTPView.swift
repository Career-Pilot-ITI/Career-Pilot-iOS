//
//  OTPCodeView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import SwiftUI

struct OTPView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    @State private var code: String
    
    init(code: String = "") {
        self._code = State(initialValue: code)
    }
    
    var body: some View {
        
        ZStack {
            Color.darkBackGround.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Enter your code")
                    .foregroundStyle(.white)
                    .font(Font.pageTitle)
                    .padding(.bottom,8)
                HStack{
                    Text("Sent to")
                        .foregroundStyle(.white)
                        .font(Font.bodyAppRegular)
                    Text("+20 101 234 5678")
                        .foregroundStyle(.white)
                        .font(Font.bodyAppRegular)
                }
                .padding(.bottom,36)
                
                OTPCodeView(
                    code: $code,
                    phoneNumber: "+20 101 234 5678") { completed in
                        coordinator.push(.successOTPScreen)
                    } onResend: {
                        // handle resend code
                    }
                    
                Spacer()
            }
            .padding(.top, 32)
            .padding(.horizontal, Spacing.s24)
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(code: "")
            .environmentObject(AppCoordinator())
    }
}
