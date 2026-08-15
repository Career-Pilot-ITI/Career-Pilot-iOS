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
                Image("coin").font(.size24Semibold).foregroundColor(.primary)
                Text("\(coinNumber)").font(.size24Semibold)
                Text("coins").font(.size16Bold)
                Spacer()
                Text("EGP").font(.size18Medium).foregroundColor(isClicked ? Color.primary : Color.gray600 )
                Text("\(price)").font(.size18Medium).foregroundColor(isClicked ? Color.primary : Color.gray600)
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
                   
                    .fill(isClicked ? Color.primary.opacity(0.06) : Color.gray400.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.r20)
                           
                            .stroke(isClicked ? Color.primary : Color.gray400, lineWidth: 1)
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
