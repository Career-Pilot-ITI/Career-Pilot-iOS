//
//  SubscribtionCheckoutView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 19/07/2026.
//

import SwiftUI

struct SubscribtionCheckoutView: View {
  
    var product : String
    var productPrice : String
    var total : String
    var body: some View {
        VStack(){
            HStack(spacing : 12){
                customIcon(icon: "king")
                VStack(alignment: .leading , spacing: 3){
                    Text("Upgrading to").font(.size12Medium).foregroundColor(.gray400)
                    Text("\(product)").font(.size18Bold).foregroundColor(.primaryNavy)
                    
                }.frame(maxWidth:.infinity , alignment: .leading)
                
              
            }
            Divider().frame(height: 1).background(Color.gray400)
            Group{
                Spacer().frame(height:Spacing.s8)
               HStack{
                   Text("Monthly price").font(.size14Medium).foregroundColor(.gray600)
                   Spacer()
                   Text("EGP").font(.size16Medium).foregroundColor(.primaryNavy)
                   Text("\(productPrice)").font(.size16Medium).foregroundColor(.primaryNavy)
               }
                Spacer().frame(height:Spacing.s8)
               HStack{
                   Text("Billing cycle").font(.size14Medium).foregroundColor(.gray600)
                   Spacer()
                   
                   Text("\(product)").font(.size16Medium).foregroundColor(.primaryNavy)
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
         Image(icon)
             .foregroundColor(.activeColour)
             .frame(width: 44, height: 44)
             .background(
                 RoundedRectangle(cornerRadius: Radius.r12 )
                     .fill(Color.activeColour.opacity(0.1))
             )
     }
    
}

//struct SubscribtionCheckoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscribtionCheckoutView()
//    }
//}
