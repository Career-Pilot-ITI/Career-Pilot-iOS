//
//  ProfileFormSettings.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/07/2026.
//

import SwiftUI

struct ProfileFormSettings: View {
    var body: some View {
  
            VStack(alignment: .leading, spacing: 14) {
                CustomProfileTextField(icon: "PersonIcon", title: "Full Name", text: $userData.fullName)
                Divider().background(Color.gray400).frame(height: 4)

                CustomProfileTextField(icon: "email", title: "Email", text: $userData.email)
                Divider().background(Color.gray400).frame(height: 4)

                CustomProfileTextField(icon: "tittle", title: "CURRENT ROLE / TITTLE", text: $userData.title)
                Divider().background(Color.gray400).frame(height: 4)

                CustomProfileTextField(icon: "ExperinceLevel", title: "EXPERIENCE LEVEL", text: $userData.experienceLevel)

                Spacer().frame(height: Spacing.lg)
                Text("SKILLS DETECTED").font(.labelAppSemiBold).foregroundColor(.gray400)

                SkillDetection(skills: userData.skills, extraCount: extraCount)
            }
            .padding([.vertical, .horizontal], Spacing.xl)
            .foregroundColor(.lightBackGround)

          }
    
    
}



