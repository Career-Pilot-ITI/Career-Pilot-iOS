//
//  CoinTopView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct CoinTopView: View {
    var body: some View {
        VStack(alignment:.leading , spacing: 0){
            Text("Get Coins").font(.size24Semibold)
            Spacer().frame(height: Spacing.s4)
            Text("Unlock premium features and extra sessions.").font(.size14Medium)
            
        }.padding(.horizontal , 0).frame(maxWidth: .infinity)
    }
}

//struct CoinTopView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoinTopView()
//    }
//}
