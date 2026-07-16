//
//  CustomButton.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 15/07/2026.
//

import SwiftUI

struct CustomButton: View {
    //Properties
    var showArrow: Bool = true
    var buttonTitle: String
    
    //Actions
    var onClick: () -> Void
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: Spacing.s16)
            .frame(width: 350, height: 52)
            .foregroundColor(.activeColour)
            .overlay{
                HStack{
                    Text(buttonTitle)
                        .font(.buttonLabel)
                        .foregroundColor(.gray100)
                        
                    if showArrow{
                        Image(systemName: "arrow.right")
                            .foregroundColor(.gray100)                        
                    }
                }
            }
            .onTapGesture(perform: onClick)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(buttonTitle: "Continue"){
            print("Clicked")
        }
    }
}
