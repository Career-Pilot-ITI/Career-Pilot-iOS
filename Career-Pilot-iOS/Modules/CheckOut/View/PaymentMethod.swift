//
//  PaymentMethod.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct PaymentMethod: View {
    var body: some View {
        VStack{
            PaymentCard(image: "paymob", title: "PayMob", subTitle: "Credit/DebtCard", perfixIcon: "")
            PaymentCard(image: "", title: "Apple Pay", subTitle: "Touch ID or Face ID", perfixIcon: "")
        }
    }
    @ViewBuilder
    private func PaymentCard(image : String , title : String , subTitle  : String , perfixIcon : String ) -> some View {
        HStack(){
            Image(image)
            VStack{
                Text(title)
                Text(subTitle)
            }
            Image(perfixIcon)
            
        }
    }
    
}


