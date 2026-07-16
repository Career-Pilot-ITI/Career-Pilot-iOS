//
//  ProfileCard.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct ProfileCard: View {
    var body: some View {
        HStack(spacing:16){
            Image("colorfulIcon")
            VStack (alignment:.leading){
                Text("Sarah Chen").font(.cardTitleSmallerBolded).foregroundColor(.primaryNavy)
                Text("sarah.chen@example.com")
                    .font(.bodySmall).foregroundColor(Color.gray400)
            }
            Spacer()
            Image(systemName: "pencil").frame(width: 18 , height: 18).foregroundColor(.gray400)
            
        }.frame(maxWidth: .infinity) 
            .padding([.vertical, .horizontal], Spacing.s12)
            .background(
                RoundedRectangle(cornerRadius: Radius.r12)
                    .fill(Color.white)
            )
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard()
    }
}
