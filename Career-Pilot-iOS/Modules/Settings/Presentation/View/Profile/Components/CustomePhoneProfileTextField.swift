//
//  CustomePhoneProfileTextField.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import SwiftUI

struct CustomePhoneProfileTextField: View {
    var icon : String
    let title: String
    var body: some View {
        HStack(spacing:12){
            customIcon(icon: icon)
            VStack(alignment: .leading, spacing: 4) {
                Text(title.uppercased())
                    .font(.caption.bold())
                    .foregroundColor(.gray400)
                HStack{
                    Text("01554132837").font(.bodySmallSemiBold).foregroundColor(.gray400)
                    Spacer()
                    Text("VERIFIED")
                        .font(.smallLabel10n)
                        .padding(.vertical , 2).padding(.horizontal , Spacing.sm)
                        .background(
                            Color.primaryTeal.opacity(0.1),
                            in: RoundedRectangle(cornerRadius: Radius.xl)
                        )
                        .foregroundStyle(Color.primaryTeal)
                    
                }
                Spacer().frame(height: Spacing.xs)
                Divider()
                    .frame(maxWidth: 210)
                    .foregroundColor(Color.gray400)
            }
            Spacer()
            Image("lock")
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: Radius.lg )
                        .fill(Color.primaryTeal.opacity(0.1))
                )
        }}
   @ViewBuilder
    private func customIcon(icon: String  ) -> some View {
        Image(icon)
            .foregroundColor(.primaryNavy)
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg )
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
