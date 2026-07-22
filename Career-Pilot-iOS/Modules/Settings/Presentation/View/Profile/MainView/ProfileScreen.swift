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
                    Spacer().frame(height: Spacing.lg)
                    ProfileFormSettings()
                    Spacer().frame(height: Spacing.lg)
                    Text("CV/ Resume").font(.labelAppBold).foregroundColor(.gray400)
                    Spacer().frame(height: Spacing.lg)
                    CvResumeSettingsProfile()
                    Spacer().frame(height: Spacing.lg)
                    Spacer()
                    Text("SkILLS  DETECTED").font(.labelAppBold).foregroundColor(.gray400)
                }.padding(.horizontal, Spacing.lg)
                Spacer().frame(height: Spacing.lg)
                SkillsDetectedSettingsProfile()
                
                
                       
            }.background(Color.gray100)
        }
    
    
}

//struct ProfileScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileScreen()
//    }
//}
