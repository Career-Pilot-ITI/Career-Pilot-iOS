//
//  SettingsProfileTopView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 16/07/2026.
//

import SwiftUI

struct SettingsProfileTopView: View {
    var isSaveEnabled: Bool
    var onSave: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: onSave) {
                Text("Save")
                    .foregroundColor(isSaveEnabled ? .activeColour : .gray200)
            }
            .disabled(!isSaveEnabled)
        }
        .background(Color.gray100)
    }
}

//struct SettingsProfileTopView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsProfileTopView()
//    }
//}
