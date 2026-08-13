//
//  ProfileForm.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct ProfileForm: View {
    @Binding var userData: OnBoardingUser
    @Binding var emailErrorMessage :  String?
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
                ProfilePhoto(image:$userData.profileImage, onImagePicked: {data in } )
                Text("Tap to add a profile photo").font(.size12Medium).foregroundColor(.gray400)
                Divider().background(Color.gray400).frame(height: 4)
               
            }.frame( alignment: .center)
       
            Group{
                CustomProfileTextField(icon: "PersonIcon", title: "Full Name", autocapitalization: .words, text: $userData.fullName)
                
                Divider().background(Color.gray400).frame(height: 4)

                CustomProfileTextField(icon: "email", title: "Email", autocapitalization: .never , text: $userData.email , errorMessage: emailErrorMessage ).onChange(of:userData.email){ _ in
                    emailErrorMessage = nil
                }
                Divider().background(Color.gray400).frame(height: 4)

                CustomProfileTextField(icon: "tittle", title: "CURRENT ROLE / TITTLE", autocapitalization: .never,text: $userData.title)
                Divider().background(Color.gray400).frame(height: 4)
                ExperienceLevelSelector(selected: $userData.experienceLevel)

                CustomProfileTextField(icon: "experienceLevel", title: "EXPERIENCE LEVEL", text: $userData.experienceLevel)

                Spacer().frame(height: Spacing.s20)
            }
            Text("SKILLS DETECTED")
                .font(.size14Semibold)
                .foregroundColor(.gray400)
                .frame(maxWidth: .infinity , alignment: .leading)
            
            if userData.cv == nil {
                SkillsInputView(selectedSkills: skillNamesBinding)
            } else {
                SkillDetection(skills: userData.skills.map { $0.skillName }, extraCount: extraCount)
            }
  
        }
        .padding([.vertical, .horizontal], Spacing.s20)
        .foregroundColor(.background)
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

//#Preview {
//    struct ContainerView: View {
//        @State private var userData = OnBoardingUser(
//            email: "ahmed@example.com",
//            title: "iOS Developer",
//            avatarUrl: nil,
//            avatarFileId: nil,
//            gender: "Male",
//            experienceLevel: "Mid-Level",
//            skills: [
//                Skill(skillName: "Swift", category: "Mobile", performanceScore: 90, timesAssessed: 5, lastAssessedAt: "2026-08-01"),
//                Skill(skillName: "SwiftUI", category: "Mobile", performanceScore: 85, timesAssessed: 4, lastAssessedAt: "2026-08-10")
//            ],
//            profileImageData: nil,
//            firstName: "Ahmed",
//            lastName: "El-Sayyad",
//            cv: nil,
//            selectedTrack:nil
//        )
//
//        var body: some View {
//            ScrollView {
//                ProfileForm(userData: $userData)
//            }
//        }
//    }
//
//    return ContainerView()
//}
