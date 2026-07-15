//
//  ProfileForm.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct ProfileForm: View {
    var userData: UserData
        
        @State private var fullName: String
        @State private var title: String
        @State private var email: String
    @State private var exprinceLevel: String
    private var skills : [String]
        
        init(userData: UserData) {
            self.userData = userData
         
            _fullName = State(initialValue: userData.fullName)
            _title = State(initialValue: userData.title)
            _email = State(initialValue: userData.email)
            _exprinceLevel = State(initialValue: userData.experienceLevel)
            self.skills = userData.skills
        }
    let extraCount = 8
    var body: some View {
        VStack(alignment: .leading, spacing: 14){
            CustomProfileTextField(icon: "PersonIcon", title: "Full Name", text:$fullName )
            Divider().background(Color.gray100 ).frame(height: 2)
            
            CustomProfileTextField(icon: "Email", title: "Email", text:$email )
            
            Divider().background(Color.gray100 ).frame(height: 2)
            CustomProfileTextField(icon: "Tittle", title: "CURRENT ROLE / TITTLE", text:$title )
            Divider().background(Color.gray100 ).frame(height: 2)
            CustomProfileTextField(icon: "ExperinceLevel", title: "EXPERIENCE LEVEL", text:$email)
            Spacer().frame(height: Spacing.lg)
            Text("SKILLS DETECTED").font(.labelAppSemiBold).foregroundColor(.gray400)
            
    
            SkillDetection(skills: skills, extraCount: extraCount)
        }.padding([.vertical,.horizontal] , Spacing.xl).foregroundColor(.lightBackGround)
    }
    @ViewBuilder
    private func SkillDetection(skills : [String] , extraCount : Int) -> some  View {
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
//        ProfileForm(userData: UserData(email: "eyad@gmail.com", title: "Developer", experienceLevel: "Junior", skills:  ["React", "Node.js", "TypeScript", "Python", "AWS", "System Design"], firstName: "Eyad", lastName: "Waleed"))
//    }
//}


