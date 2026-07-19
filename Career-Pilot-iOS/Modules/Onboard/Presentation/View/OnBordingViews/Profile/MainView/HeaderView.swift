//
//  HeaderView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack (alignment:.leading){
            HStack(spacing: 12){
                Image("check")
                Text("Ready to go!").font(.size16Bold).foregroundColor(.activeColour)
            }

            Spacer().frame(height: Spacing.s8)
            Text("Your profile is set up").font(.size24Semibold).foregroundColor(.primaryNavy)
            Spacer().frame(height: Spacing.s4)
            Text("Here's what we found. You  can always update this later.").font(.size14Medium).foregroundColor(.gray600)
        }
      
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}





