//
//  ProfileScreen.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/07/2026.
//

import SwiftUI

struct ProfileScreen: View {
    @State  var user : UserInformation
    var body: some View {
            ScrollView {
                VStack (alignment: .leading, spacing : 0){
                    SettingsProfileTopView(){}
                    Spacer().frame(height: Spacing.s16)
                    ProfileFormSettings()
                    Spacer().frame(height: Spacing.s16)
                    Text("CV/ Resume").font(.size14Semibold).foregroundColor(.gray400)
                    Spacer().frame(height: Spacing.s16)
                    CvResumeSettingsProfile()
                    Spacer().frame(height: Spacing.s16)
                    Spacer()
                    Text("SkILLS  DETECTED").font(.size14Semibold).foregroundColor(.gray400)
                }.padding(.horizontal, Spacing.s16)
                Spacer().frame(height: Spacing.s16)
                SkillsDetectedSettingsProfile()
                
                
                       
            }.background(Color.gray100)
        }
    
    
}

//struct ProfileScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileScreen()
//    }
//}
