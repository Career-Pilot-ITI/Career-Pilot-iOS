//
//  CheckOutView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct CheckOutView: View {
    var body: some View {
      
        VStack(){
            CheckOutTopView()
            Spacer().frame(height: Spacing.s20)
            TotalPaymentView(product: "500 Coin", productPrice: "200", total:
            "200")
            
        }
        
    }
}

//struct CheckOutView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckOutView()
//    }
//}
