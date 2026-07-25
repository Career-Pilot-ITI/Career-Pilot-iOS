//
//  TotalPaymentView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct CoinPackCheckOutView: View {
    var product : String
    var productPrice : String
    var total : String
    var body: some View {
        VStack(){
            HStack(spacing : 12){
                customIcon(icon: "star.fill")
                VStack(alignment: .leading , spacing: 3){
                    Text("Purches").font(.size12Medium).foregroundColor(.gray400)
                    Text("\(product)").font(.size18Bold).foregroundColor(.primaryNavy)
                    
                }.frame(maxWidth:.infinity , alignment: .leading)
                
              
            }
            Divider().frame(height: 1).background(Color.gray400)
            Group{
                Spacer().frame(height:Spacing.s8)
               HStack{
                   Text("Price per pack").font(.size14Medium).foregroundColor(.gray600)
                   Spacer()
                   Text("EGP").font(.size16Medium).foregroundColor(.primaryNavy)
                   Text("\(productPrice)").font(.size16Medium).foregroundColor(.primaryNavy)
               }
                Spacer().frame(height:Spacing.s8)
               HStack{
                   Text("Coins included").font(.size14Medium).foregroundColor(.gray600)
                   Spacer()
                   
                   Text("\(product)").font(.size16Medium).foregroundColor(.primaryNavy)
               }
                Spacer().frame(height:Spacing.s8)

               HStack{
                   Text("Expire").font(.size14Medium).foregroundColor(.gray600)
                   Spacer()
                   Text("Never").font(.size16Medium).foregroundColor(.primaryNavy)
               }
            }
            
           Divider().frame(height: 1).background(Color.gray400)
            
            Spacer().frame(height:Spacing.s16)

           HStack{
               Text("Total").font(.size16Bold).foregroundColor(.primaryNavy)
               Spacer()
               Text("EGP ").font(.size18Medium).foregroundColor(.activeColour)
               Text("\(total)").font(.size18Medium).foregroundColor(.activeColour)
           }
            

            
        }.padding(.horizontal , Spacing.s20).padding(.vertical , Spacing.s20).background(Color.white
                                                                                         , in : RoundedRectangle(cornerRadius: Radius.r16 ))
    }
    @ViewBuilder
     private func customIcon(icon: String) -> some View {
         Image(systemName:icon)
             .foregroundColor(.activeColour)
             .frame(width: 44, height: 44)
             .background(
                 RoundedRectangle(cornerRadius: Radius.r12 )
                     .fill(Color.activeColour.opacity(0.1))
             )
     }
    
}

struct TotalPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        CoinPackCheckOutView(product: "500 Coion", productPrice: "119", total: "119")
    }
}
