//
//  profile.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct profile: View {
    @State private var userData = UserData(
        email: "eyad@gmail.com",
        title: "developer",
        experienceLevel: "Senior",
        skills: ["C++", "C"],
        firstName: "Eyad",
        lastName: "Waleed"
    )

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

            CustomButton(buttonTitle: "Start Practising") {

            }
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)


        }
        .padding(.horizontal, Spacing.s20)
        .background(Color.gray100)
    }
}

struct profile_Previews: PreviewProvider {
    static var previews: some View {
        profile()
    }
}
