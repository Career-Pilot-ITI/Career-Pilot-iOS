//
//  profile.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct profile: View {
    @Binding var userData: UserData
    


    var body: some View {
        ScrollView{
            VStack(spacing: 24) {
                HeaderView()

                ProfileForm(userData: $userData)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.r12)
                            .fill(Color.white)
                    )
                    .shadow(
                        color: Color.black.opacity(0.08),
                        radius: 12,
                        x: 0,
                        y: 4
                    )

                FreeSessionBanner()
                
            }
            .padding(.horizontal, Spacing.s20)
        }
        .background(Color.gray100)
    }
}
//struct profile_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewWrapper()
//    }
//    
//    struct PreviewWrapper: View {
//        @State private var userData = UserData(
//            email: "eyad@gmail.com",
//            title: "developer",
//            experienceLevel: "Senior",
//            skills: [],
//            firstName: "Eyad",
//            lastName: "Waleed"
//        )
//        
//        var body: some View {
//            profile(userData: $userData)
//        }
//    }
//}
