//
//  profile.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct profile: View {
    @State var userData: UserData
    
    private var isFormValid: Bool {
        !userData.fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !userData.email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !userData.title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !userData.experienceLevel.trimmingCharacters(in: .whitespaces).isEmpty
    }

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

            CustomButton(buttonTitle: "Start Practising") {

            }
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)


        }
        .padding(.horizontal, Spacing.xl)
        .background(Color.gray100)
    }
}

struct profile_Previews: PreviewProvider {
    static var previews: some View {
        var userData =  UserData(
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
