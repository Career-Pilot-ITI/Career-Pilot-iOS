//
//  CustomButton.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 15/07/2026.
//

import SwiftUI
struct CustomButton: View {

    var isButtonEnabeld: Bool = true
    var showArrow = true
    var buttonTitle: String
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {

            HStack {
                Text(buttonTitle)

                if showArrow {
                    Image(systemName: "arrow.right")

                }
            }
            .font(.caption)
            .foregroundStyle(Color.gray100)
            .frame(width: 350, height: 52)
            .background(Color.activeColour)
            .clipShape(Capsule())
        }
        .disabled(!isButtonEnabeld)
        .opacity(isButtonEnabeld ? 1 : 0.5)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(isButtonEnabeld: true, buttonTitle: "Continue"){
            print("Clicked")
        }
    }
}
