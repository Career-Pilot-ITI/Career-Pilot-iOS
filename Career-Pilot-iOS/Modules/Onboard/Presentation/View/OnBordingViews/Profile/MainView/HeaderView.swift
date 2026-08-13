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
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.primary)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image("right")
                            .renderingMode(.template)
                            .foregroundStyle(Color(.systemBackground))
                    }
                
                Text("Ready to go!")
                    .font(.size16Bold)
                    .foregroundColor(.primary)
            }

            Spacer().frame(height: Spacing.s8)
            Text("Your profile is set up").font(.size24Semibold)
            Spacer().frame(height: Spacing.s4)
            Text("Here's what we found. You  can always update this later.").font(.size14Medium)
        }
      
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}





