//
//  CheckOutView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI
enum CheckoutItem {
    case subscription(plan: String, monthlyPrice: String, billingCycle: String, total: String)
    case coinPack(name: String, pricePerPack: String, coinsIncluded: String, total: String)
}
struct CheckOutView: View {
    let checkoutItem: CheckoutItem
    @State private var selectedPaymentMethod: String = "paymob"
    
    var body: some View {
        VStack(alignment: .leading) {
            CheckOutTopView()
            
            Spacer().frame(height: Spacing.s20)
            
            switch checkoutItem {
            case .subscription(let plan, let monthlyPrice, let billingCycle, let total):
                SubscribtionCheckoutView(
                    product: plan,
                    productPrice: monthlyPrice,
                    total: total
                )
                
            case .coinPack(let name, let pricePerPack, let coinsIncluded, let total):
                CoinPackCheckOutView(
                    product: name,
                    productPrice: pricePerPack,
                    total: total
                )
            }
            
            Spacer().frame(height: Spacing.s20)
            
            Text("PAYMENT METHOD")
                .font(.size14Semibold)
                .foregroundColor(.gray400)
            
            Spacer().frame(height: Spacing.s8)
            
            PaymentMethod(selectedMethod: $selectedPaymentMethod)
            
            Spacer()
            
           
        }
        .padding(.horizontal, Spacing.s20).background(Color.gray100)
    }
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView(checkoutItem: .subscription(
            plan: "Pro Monthly",
            monthlyPrice: "200",
            billingCycle: "Monthly",
            total: "200"
        ))
        
        CheckOutView(checkoutItem: .coinPack(
            name: "500 Coins",
            pricePerPack: "119",
            coinsIncluded: "500",
            total: "119"
        ))
    }
}
