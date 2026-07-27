//
//  ProfileCard.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct ProfileCard: View {
    var user : UserModelSettingsView
    var body: some View {
        HStack(spacing:16){
            Image("colorfulIcon")
            VStack (alignment:.leading){
                Text("\(user.fullName)").font(.size16Bold).foregroundColor(.primaryNavy)
                Text("\(user.email)")
                    .font(.size13Medium).foregroundColor(Color.gray400)
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
//
//struct ProfileCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileCard()
//    }
//}
