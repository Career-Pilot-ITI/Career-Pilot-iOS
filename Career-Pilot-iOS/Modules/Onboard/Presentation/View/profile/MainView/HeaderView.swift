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
                Text("Ready to go!").font(.cardTitleSmallerBolded).foregroundColor(.activeColour)
            }
            Spacer().frame(height: Spacing.sm)
            Text("Your profile is set up").font(.pageTitleSmaller).foregroundColor(.primaryNavy)
            Spacer().frame(height: Spacing.xs)
            Text("Here's what we found. You  can always update this later.").font(.bodyApp).foregroundColor(.gray600)
        }
      
    }
}

//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView()
//    }
//}





