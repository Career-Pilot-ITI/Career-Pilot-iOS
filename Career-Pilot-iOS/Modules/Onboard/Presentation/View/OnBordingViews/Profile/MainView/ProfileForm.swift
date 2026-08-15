//
//  ProfileForm.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//
import SwiftUI

struct ProfileForm: View {
    @Binding var userData: OnBoardingUser
    @Binding var emailErrorMessage: String?
    
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
        VStack(spacing: Spacing.s16) {
            // MARK: - Profile Photo Section
            VStack(spacing: Spacing.s8) {
                ProfilePhoto(image: $userData.profileImage, onImagePicked: { _ in })
                Text("Tap to add a profile photo")
                    .font(.size12Medium)
                    .foregroundColor(.gray400)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, Spacing.s8)
            
            // MARK: - Form Inputs
            CustomProfileTextField(
                icon: "PersonIcon",
                title: "Full Name",
                autocapitalization: .words,
                text: $userData.fullName
            )
            
            CustomProfileTextField(
                icon: "email",
                title: "Email",
                autocapitalization: .never,
                text: $userData.email,
                errorMessage: emailErrorMessage
            )
            .onChange(of: userData.email) { _ in
                emailErrorMessage = nil
            }
            
            CustomProfileTextField(
                icon: "tittle",
                title: "Current Role / Title",
                autocapitalization: .never,
                text: $userData.title
            )
            
            ExperienceLevelSelector(selected: $userData.experienceLevel)
                .padding(.top, Spacing.s4)
            
            // MARK: - Skills Section
            VStack(alignment: .leading, spacing: Spacing.s12) {
                Text("SKILLS DETECTED")
                    .font(.size14Semibold)
                    .foregroundColor(.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if userData.skills.isEmpty {
                    SkillsInputView(selectedSkills: skillNamesBinding)
                } else {
                    SkillDetection(skills: userData.skills.map { $0.skillName })
                }
            }
            .padding(.top, Spacing.s12)
        }
        .padding(Spacing.s20)
        .foregroundColor(.lightBackGround)
        .padding([.vertical, .horizontal], Spacing.s20)
        .foregroundColor(.background)
    }
    

    @ViewBuilder
    private func SkillDetection(skills: [String]) -> some View {
        let visibleSkills = Array(skills.prefix(6))
        let remainingCount = max(0, skills.count - visibleSkills.count)
        
        FlowLayout(spacing: 8) {
            ForEach(visibleSkills, id: \.self) { skill in
                SkillTag(text: skill)
            }
            
            if remainingCount > 0 {
                SkillTag(text: "+\(remainingCount) more", isMuted: true)
            }
        }
    }

}






