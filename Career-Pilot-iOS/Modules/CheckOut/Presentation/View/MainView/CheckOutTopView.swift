//
//  CheckOutTopView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct CheckOutTopView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Checkout").font(.size24Semibold).foregroundColor(.primaryNavy).frame(maxWidth: .infinity ,  alignment : .leading)
            Spacer().frame(height: Spacing.s4 )
            Text("Review your purchase before proceeding.").font(.size14Medium).foregroundColor(.gray600)
        }
    }
}

//struct CheckOutTopView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckOutTopView()
//    }
//}
