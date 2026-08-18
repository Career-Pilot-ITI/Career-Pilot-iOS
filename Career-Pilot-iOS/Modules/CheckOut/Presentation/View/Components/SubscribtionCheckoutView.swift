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
                    Text("Upgrading to").font(.size12Medium)
                    Text("\(product)").font(.size18Bold)
                    
                }.frame(maxWidth:.infinity , alignment: .leading)
                
              
            }
            Divider().frame(height: 1)
            Group{
                Spacer().frame(height:Spacing.s8)
               HStack{
                   Text("Monthly price").font(.size14Medium)
                   Spacer()
                   Text("EGP").font(.size16Medium)
                   Text("\(productPrice)").font(.size16Medium)
               }
                Spacer().frame(height:Spacing.s8)
               HStack{
                   Text("Billing cycle").font(.size14Medium)
                   Spacer()
                   
                   Text("\(product)").font(.size16Medium)
               }

            }
            
           Divider().frame(height: 1)
            
            Spacer().frame(height:Spacing.s16)

           HStack{
               Text("Total").font(.size16Bold)
               Spacer()
               Text("EGP ").font(.size18Medium).foregroundColor(.primary)
               Text("\(total)").font(.size18Medium).foregroundColor(.primary)
           }
            

            
        }
        .padding(.horizontal , Spacing.s20)
        .padding(.vertical , Spacing.s20)
        .background(
            .background.opacity(0.1),
            in : RoundedRectangle(cornerRadius: Radius.r16 ))
    }
    @ViewBuilder
     private func customIcon(icon: String) -> some View {
         Image(icon)
             .foregroundColor(.primary)
             .frame(width: 44, height: 44)
             .background(
                 RoundedRectangle(cornerRadius: Radius.r12 )
                     .fill(Color.primary.opacity(0.1))
             )
     }
    
}

//struct SubscribtionCheckoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscribtionCheckoutView()
//    }
//}
