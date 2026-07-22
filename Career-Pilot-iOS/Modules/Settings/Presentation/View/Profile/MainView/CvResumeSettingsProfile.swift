//
//  CvResumeSettingsProfile.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import SwiftUI

struct CvResumeSettingsProfile: View {
    var body: some View {
        
        VStack(alignment: .center, spacing : 12){
            HStack{
                customIcon(icon: "paper", color: nil)
                VStack(alignment: .leading){
                    Text("resume file name").font(.bodyAppSemiBold).foregroundColor(.primaryNavy)
                    Text("Uploaded data & time & size").font(.labelApp).foregroundColor(.gray400)
                }
                
                Spacer()
                customIcon(icon: "done_icon", color: .successColour)
            }
           
            Button(action: {}) {
                HStack {
                    Image("download_icon")
                    Text("Re-uploadCV")
                        .font(.cardTitleSmallerBolded)
                }
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.md)
                .foregroundStyle(Color.primaryNavy)
            }.frame(maxWidth: .infinity)
            .background(
                Color.primaryNavy.opacity(0.06),
                in: RoundedRectangle(cornerRadius: Radius.md)
            )
            
            
            Text("Re-uploading your CV will refresh your detected skills and recommended track").font(.labelApp).foregroundColor(.gray400)
            
        }.padding(.vertical , Spacing.xl).padding(.horizontal , Spacing.xl).background(Color.white , in : RoundedRectangle(cornerRadius: Radius.card)).shadow(
            color: Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 4
        )
        
    }
    @ViewBuilder
    private func customIcon(icon: String, color: Color?) -> some View {
        let resolvedColor = color ?? .activeColour
        
        Image(icon).resizable().renderingMode(.template).padding([.vertical , .horizontal] , 11).frame(width: 40, height: 40)
            .foregroundColor(resolvedColor)
            
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(resolvedColor.opacity(0.1))
            )
    }
        
}

struct CvResumeSettingsProfile_Previews: PreviewProvider {
    static var previews: some View {
        CvResumeSettingsProfile()
    }
}
