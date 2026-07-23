//
//  SuggestionIconView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct SuggestionIconView: View {
    let icon: String
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 18))
            .foregroundColor(Color.activeColour)
            .padding(.all,9)
            .background {
                RoundedRectangle(cornerRadius: Radius.r10)
                    .fill(Color.activeColour)
                    .opacity(0.12)
            }
    }
}
//
//#Preview {
//    SuggestionIconView(icon: "target")
//}
