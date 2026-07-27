//
//  SettingsProfileTopView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/07/2026.
//

import SwiftUI

struct SettingsProfileTopView: View {
    var onSave: () -> Void
    var body: some View {
        HStack{
            Text("Edit Profile")
            Spacer() 
            Button(action: {
                onSave()
                
            }){
                Text("Save").foregroundColor(.gray200)
                
            }
        }.background(Color.gray100)
        
        
    }
}

//struct SettingsProfileTopView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsProfileTopView()
//    }
//}
