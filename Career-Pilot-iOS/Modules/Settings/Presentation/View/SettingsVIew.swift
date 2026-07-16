//
//  SettingsVIew.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct SettingsVIew: View {
    var body: some View {
        VStack(alignment: .leading){
            Group{
                Text("Settings").font(.size22Semibold).foregroundColor(.primaryNavy)
                ProfileCard()
            }
            Group{
                Spacer().frame(height: Spacing.s12)
                Text("ACCOUNT").font(.size12Semibold).foregroundColor(.gray400)
                Spacer().frame(height: Spacing.s4)
                AccountSettingsView()
                Spacer().frame(height: Spacing.s32)
                Text("Support & Legal").font(.size12Semibold).foregroundColor(.gray400)
                Spacer().frame(height: Spacing.s4)
               SupportAndLeagalSettingsView()
            }
    
            Spacer().frame(height: Spacing.s32)
            Text("Danger Zone").font(.size12Semibold).foregroundColor(.gray400)
            Spacer().frame(height: Spacing.s4)
           
                       HStack(spacing: 12) {
                           Image(systemName: "trash.fill")
                               .foregroundColor(.errorColour)
                               .frame(width: 44, height: 44)
                               .background(
                                RoundedRectangle(cornerRadius: Radius.r20)
                                       .fill(Color.errorColour.opacity(0.08))
                               )
                           
                           VStack(alignment: .leading, spacing: 2) {
                               Text("Request Data Deletion")
                                   .font(.size14Medium)
                                   .foregroundColor(.errorColour)
                               Text("Permanently delete account & data")
                                   .font(.caption)
                                   .foregroundColor(.gray400)
                           }
                           
                           Spacer()
                           
                           Image(systemName: "chevron.right")
                               .foregroundColor(.gray400)
                               .font(.caption.bold())
                       }
                       .padding(.horizontal, Spacing.s20)
                       .padding(.vertical, Spacing.s8)
                       .background(
                        RoundedRectangle(cornerRadius: Radius.r12)
                               .fill(Color.white)
                       )
                       
            Spacer().frame(height: Spacing.s8)
                       

                       HStack {
                           Spacer()
                           HStack(spacing: 8) {
                               Image(systemName: "rectangle.portrait.and.arrow.right")
                                   .foregroundColor(.errorColour)
                               Text("Sign Out")
                                   .font(.size14Medium)
                                   .foregroundColor(.errorColour)
                           }
                           Spacer()
                       }
                       .padding(.vertical, Spacing.s12)
                       .background(
                        RoundedRectangle(cornerRadius: Radius.r12)
                               .fill(Color.errorColour.opacity(0.08))
                       )

            
        }.padding(.vertical, Spacing.s24)
            .padding(.horizontal, Spacing.s32).background(Color.gray100)


    }
}

struct SettingsVIew_Previews: PreviewProvider {
    static var previews: some View {
        SettingsVIew()
    }
}
