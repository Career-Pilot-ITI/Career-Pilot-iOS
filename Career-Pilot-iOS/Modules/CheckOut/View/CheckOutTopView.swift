//
//  CheckOutTopView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct CheckOutTopView: View {
    var body: some View {
        VStack(){
            Text("Checkout").font(.size24Semibold.bold()).foregroundColor(.primaryNavy)
            Spacer().frame(height: Spacing.s4 )
            Text("Complete your upgrade to Plus.").font(.size14Medium).foregroundColor(.gray600)
        }
    }
}

//struct CheckOutTopView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckOutTopView()
//    }
//}
