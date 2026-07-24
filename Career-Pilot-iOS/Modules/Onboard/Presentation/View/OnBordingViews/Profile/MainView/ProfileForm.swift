//
//  ProfileForm.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct ProfileForm: View {
    @Binding var userData: OnBoardingUser
    private var skillNamesBinding: Binding<[String]> {
        Binding(
            get: { userData.skills.map { $0.skillName } },
            set: { newNames in
                userData.skills = newNames
                    .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                    .map { name in
                        if let existing = userData.skills.first(where: { $0.skillName == name }) {
                            return existing
                        }
                        return Skill(skillName: name, category: "", performanceScore: 0, timesAssessed: 0, lastAssessedAt: "")
                    }
            }
        )
    }
    let extraCount = 8

    var body: some View {
        VStack( spacing: 14) {
            Group{
                ProfilePhoto(image:$userData.profileImage )
                Text("Tap to add a profile photo").font(.size12Medium).foregroundColor(.gray400)
                Divider().background(Color.gray400).frame(height: 4)
               
            }.frame( alignment: .center)
       
            Group{
                CustomProfileTextField(icon: "PersonIcon", title: "Full Name", text: $userData.fullName)
                Divider().background(Color.gray400).frame(height: 4)

                CustomProfileTextField(icon: "email", title: "Email", text: $userData.email)
                Divider().background(Color.gray400).frame(height: 4)

                CustomProfileTextField(icon: "tittle", title: "CURRENT ROLE / TITTLE", text: $userData.title)
                Divider().background(Color.gray400).frame(height: 4)

                CustomProfileTextField(icon: "ExperinceLevel", title: "EXPERIENCE LEVEL", text: $userData.experienceLevel)

                Spacer().frame(height: Spacing.s20)
            }
            Text("SKILLS DETECTED").font(.size14Semibold).foregroundColor(.gray400).frame(maxWidth: .infinity , alignment: .leading)
            if userData.cv == nil {
                SkillsInputView(selectedSkills: skillNamesBinding)
            } else {
                SkillDetection(skills: userData.skills.map { $0.skillName }, extraCount: extraCount)
            }
  
        }
        .padding([.vertical, .horizontal], Spacing.s20)
        .foregroundColor(.lightBackGround)
    }

    @ViewBuilder
    private func SkillDetection(skills: [String], extraCount: Int) -> some View {
        FlowLayout(spacing: 8) {
            ForEach(skills, id: \.self) { skill in
                SkillTag(text: skill)
            }
            SkillTag(text: "+\(extraCount) more", isMuted: true)
        }
    }
}

//struct ProfileForm_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileForm(userData: .constant(UserData(email: "eyad@gmail.com", title: "Developer", experienceLevel: "Junior", skills: ["React", "Node.js", "TypeScript", "Python", "AWS", "System Design"], firstName: "Eyad", lastName: "Waleed")))
//    }
//}
