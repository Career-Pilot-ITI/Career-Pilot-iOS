//
//  SendEmailButton.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.

import SwiftUI

struct SendEmailButton: View {
    var onSend: () -> Void = {}

    var body: some View {
        Button(action: onSend) {
            Label("Send Email", systemImage: "envelope.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
        }
        .background(Color.matchOrange)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
//
//#Preview {
//    SendEmailButton()
//        .padding()
//        .background(Color.screenBackground)
//}
