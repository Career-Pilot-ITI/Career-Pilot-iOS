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
                .padding(.vertical, 15)
        }
        .frame(maxWidth: .infinity)
        .background(Color.primary)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

//#Preview {
//    SendEmailButton()
//        .padding()
//        .background(Color.screenBackground)
//}
