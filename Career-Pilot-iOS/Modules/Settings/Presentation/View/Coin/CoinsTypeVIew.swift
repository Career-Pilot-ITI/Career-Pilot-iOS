//
//  CoinsTypeVIew.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct CoinsTypeVIew: View {
    @Binding var  isClicked : Bool
    var  price : String
    var details : String
    var coinNumber : String
    var subTitle : String
    var onTap : () -> Void
    var body: some View {
        VStack(alignment:.leading){
            HStack(spacing:8){
                Image("coin").font(.size24Semibold).foregroundColor(.primaryNavy)
                Text("\(coinNumber)").font(.size24Semibold).foregroundColor(.primaryNavy)
                Text("coins").font(.size16Bold).foregroundColor(.primaryNavy)
                Spacer()
                Text("EGP").font(.size18Medium).foregroundColor(isClicked ? Color.activeColour : Color.primaryNavy )
                Text("\(price)").font(.size18Medium).foregroundColor(isClicked ? Color.activeColour : Color.primaryNavy)
            }
            Spacer().frame(height:Spacing.s4)
            HStack{
                Text("\(details)").font(.size13Medium).foregroundColor(.gray600)
                Spacer()
                if(isClicked){
                    Image("clicked")
                }
              
            }
          
        }.padding([.vertical, .horizontal], Spacing.s20)
            .background(
                RoundedRectangle(cornerRadius: Radius.r20)
                   
                    .fill(isClicked ? Color.activeColour.opacity(0.06) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.r20)
                           
                            .stroke(isClicked ? Color.activeColour : Color.gray200, lineWidth: 1)
                    )
            )
            .onTapGesture {
                onTap()
            }
        
    }}

//struct CoinsTypeVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var isClick : Bool = true
//        CoinsTypeVIew(isClicked: $isClick, price:"150" , coinNumber: "200", onTap: {
//            isClick.toggle()
//        })
//    }
//}
