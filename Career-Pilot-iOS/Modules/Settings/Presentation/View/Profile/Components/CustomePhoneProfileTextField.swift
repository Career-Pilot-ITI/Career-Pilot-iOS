//
//  CustomePhoneProfileTextField.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import SwiftUI

struct CustomePhoneProfileTextField: View {
    var icon : String
    @Binding var phoneNumber: String
    let title: String
    var body: some View {
        HStack(spacing:12){
            customIcon(icon: icon)
            VStack(alignment: .leading, spacing: 4) {
                Text(title.uppercased())
                    .font(.caption.bold())
                    .foregroundColor(.gray400)
                HStack{
                    Text(phoneNumber).font(.size12Bold).foregroundColor(.gray400)
                    Spacer()
                    Text("VERIFIED")
                        .font(.size12Medium)
                        .padding(.vertical , 2).padding(.horizontal , Spacing.s4)
                        .background(
                            Color.primaryTeal.opacity(0.1),
                            in: RoundedRectangle(cornerRadius: Radius.r20)
                        )
                        .foregroundStyle(Color.primaryTeal)
                    
                }
                Spacer().frame(height: Spacing.s8)
                Divider()
                    .frame(maxWidth: 210)
                    .background(Color.gray400)
            }
            Spacer()
            Image("lock")
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: Radius.r16 )
                        .fill(Color.primaryTeal.opacity(0.1))
                )
        }}
   @ViewBuilder
    private func customIcon(icon: String  ) -> some View {
        Image(icon)
            .foregroundColor(.primaryNavy)
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: Radius.r16 )
                    .fill(Color.primaryNavy.opacity(0.06))
            )
    }
}
//
//struct CustomePhoneProfileTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomePhoneProfileTextField(icon: "phone", title: "PhoneNumber")
//    }
//}
