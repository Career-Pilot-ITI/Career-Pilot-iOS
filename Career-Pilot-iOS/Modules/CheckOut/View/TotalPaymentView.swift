//
//  TotalPaymentView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct TotalPaymentView: View {
    var product : String
    var productPrice : String
    var total : String
    var body: some View {
        VStack(){
            HStack(){
                Text("\(product)").font(.size14Medium).foregroundColor(.gray600)
                Spacer()
                Text("EGP ").font(.size16Medium).foregroundColor(.primaryNavy)
                Text("\(productPrice)").font(.size16Medium).foregroundColor(.primaryNavy)
            }
            Divider().frame(height: 1).background(Color.gray400)
            HStack(){
                Text("Total").font(.size16Bold).foregroundColor(.primaryNavy)
                Spacer()
                Text("EGP").font(.size20Semibold).foregroundColor(.activeColour)
                Text("\(total)").font(.size20Semibold).foregroundColor(.activeColour)
            }
            
        }.padding(.horizontal , Spacing.s20).padding(.vertical , Spacing.s20).background(Color.white
                                                                                         , in : RoundedRectangle(cornerRadius: Radius.r16 ))
    }
}

//struct TotalPaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TotalPaymentView()
//    }
//}
