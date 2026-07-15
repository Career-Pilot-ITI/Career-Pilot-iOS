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
        VStack(spacing: 24) {
            HeaderView()

            ProfileForm(userData: $userData)
                .background(
                    RoundedRectangle(cornerRadius: Radius.lg)
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
        .padding(.horizontal, Spacing.xl)
        .background(Color.gray100)
    }
}

struct profile_Previews: PreviewProvider {
    static var previews: some View {
        let userData =  UserData(
            email: "eyad@gmail.com",
            title: "developer",
            experienceLevel: "Senior",
            skills: ["C++", "C"],
            firstName: "Eyad",
            lastName: "Waleed"
        )
        ProfileForm(userData: .constant(userData))
    }
}
