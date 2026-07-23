//
//  ProfileFormSettings.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/07/2026.
//

import SwiftUI

struct ProfileFormSettings: View {
    @State  var text : String = ""
    @State var selector :String = "Senior"
    @State var trackSelector : String = "Data Science"
    var body: some View {
  
            VStack(alignment: .leading, spacing: 14) {
                Group{
                    CustomProfileTextField(icon: "PersonIcon", title: "Full Name", text: $text )
                    Divider().background(Color.gray400).frame(height: 4)

                    CustomProfileTextField(icon: "email", title: "Email", text: $text)
                    Divider().background(Color.gray400).frame(height: 4)

                 CustomePhoneProfileTextField(icon: "phone"
                                              , title: "PHONE NUMBER")
                    Divider().background(Color.gray400).frame(height: 4)
                    CustomProfileTextField(icon: "tittle", title: "CURRENT ROLE / TITTLE", text: $text  )
                    Divider().background(Color.gray400).frame(height: 4)
                }
                
                ExperienceLevelSelector(selected:$selector )
                
                Divider().background(Color.gray400).frame(height: 4)
                TrackSelector(selected: $trackSelector)
                
                
            }.padding(.vertical, Spacing.s20).padding(.horizontal , Spacing.s16).background(Color.white , in : RoundedRectangle(cornerRadius: Radius.r16)).shadow(
                color: Color.black.opacity(0.08),
                radius: 12,
                x: 0,
                y: 4
            )
            
            
            

          }
    
    
}



