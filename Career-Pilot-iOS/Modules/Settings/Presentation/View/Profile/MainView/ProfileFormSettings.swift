//
//  ProfileFormSettings.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/07/2026.
//

import SwiftUI

struct ProfileFormSettings: View {
    @Binding  var user : UserModelSettingsView
    var tracks : [Track]

    let onImagePicked: (Data) -> Void
    init(user: Binding<UserModelSettingsView>,tracks : [Track],onImagePicked: @escaping (Data) -> Void  ) {
            self._user = user
        self.tracks = tracks
        self.onImagePicked = onImagePicked
        }
    var body: some View {
  
            VStack(alignment: .leading, spacing: 14) {
                ProfilePhoto(image: $user.avatar, onImagePicked: onImagePicked) .frame(maxWidth: .infinity, alignment: .center)
                Group{
                    CustomProfileTextField(icon: "PersonIcon", title: "Full Name", text: $user.fullName )
                    Divider().background(Color.gray400).frame(height: 4)

                    CustomProfileTextField(icon: "email", title: "Email", text: $user.email)
                    Spacer().frame(height: 2)
                    Divider().background(Color.gray400).frame(height: 4)

                    CustomePhoneProfileTextField(icon: "phone", phoneNumber: $user.phoneNumber
                                              , title: "PHONE NUMBER" )
                    Divider().background(Color.gray400).frame(height: 4)
                    CustomProfileTextField(icon: "tittle", title: "CURRENT ROLE / TITTLE", text: $user.title  )
                }
                Divider().background(Color.gray400).frame(height: 4)

                ExperienceLevelSelector(selected: $user.experienceLevel )
                
                Divider().background(Color.gray400).frame(height: 4)
                TrackSelector(options: tracks, selected: $user.trackName  )
            }.padding(.vertical, Spacing.s20).padding(.horizontal , Spacing.s16).background(Color.white , in : RoundedRectangle(cornerRadius: Radius.r16)).shadow(
                color: Color.black.opacity(0.08),
                radius: 12,
                x: 0,
                y: 4
            )
            
            
            

          }
    
    
}



