//
//  SkillsDetectedSettingsProfile.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import SwiftUI

struct SkillsDetectedSettingsProfile: View {
    
    var body: some View {
        VStack(){
            SkillDetection(skills: ["C++" , "English" , "HOO" , "HEEE"] , extraCount: 5)
            Text("Skills update automatically when you re-upload your CV. They can't be edited directly.").font(.size13Medium).foregroundStyle(Color.gray400)
        }.padding(.vertical , Spacing.s20).padding(.horizontal , Spacing.s20).background(Color.white , in : RoundedRectangle(cornerRadius: Radius.r16
                                                                                          )).padding(.horizontal , Spacing.s20)
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

struct SkillsDetectedSettingsProfile_Previews: PreviewProvider {
    static var previews: some View {
        SkillsDetectedSettingsProfile()
    }
}
