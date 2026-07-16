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
                Text("Settings").font(.sectionTitle).foregroundColor(.primaryNavy)
                ProfileCard()
            }
            Group{
                Spacer().frame(height: Spacing.xl2)
                Text("ACCOUNT").font(.labelAppSemiBold).foregroundColor(.gray400)
                Spacer().frame(height: Spacing.xs)
                AccountSettingsView()
                Spacer().frame(height: Spacing.xl)
                Text("Support & Legal").font(.labelAppSemiBold).foregroundColor(.gray400)
                Spacer().frame(height: Spacing.xs)
               SupportAndLeagalSettingsView()
            }
    
            Spacer().frame(height: Spacing.xl)
            Text("Danger Zone").font(.labelAppSemiBold).foregroundColor(.gray400)
            Spacer().frame(height: Spacing.xs)
           
                       HStack(spacing: 12) {
                           Image(systemName: "trash.fill")
                               .foregroundColor(.errorColour)
                               .frame(width: 44, height: 44)
                               .background(
                                   RoundedRectangle(cornerRadius: Radius.lg)
                                       .fill(Color.errorColour.opacity(0.08))
                               )
                           
                           VStack(alignment: .leading, spacing: 2) {
                               Text("Request Data Deletion")
                                   .font(.bodyApp.bold())
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
                       .padding(.horizontal, Spacing.xl)
                       .padding(.vertical, Spacing.sm)
                       .background(
                           RoundedRectangle(cornerRadius: Radius.lg)
                               .fill(Color.white)
                       )
                       
                       Spacer().frame(height: Spacing.sm)
                       

                       HStack {
                           Spacer()
                           HStack(spacing: 8) {
                               Image(systemName: "rectangle.portrait.and.arrow.right")
                                   .foregroundColor(.errorColour)
                               Text("Sign Out")
                                   .font(.bodyApp.bold())
                                   .foregroundColor(.errorColour)
                           }
                           Spacer()
                       }
                       .padding(.vertical, Spacing.md)
                       .background(
                           RoundedRectangle(cornerRadius: Radius.lg)
                               .fill(Color.errorColour.opacity(0.08))
                       )

            
        }.padding(.vertical, Spacing.lg)
            .padding(.horizontal, Spacing.xl).background(Color.gray100)


    }
}

struct SettingsVIew_Previews: PreviewProvider {
    static var previews: some View {
        SettingsVIew()
    }
}
