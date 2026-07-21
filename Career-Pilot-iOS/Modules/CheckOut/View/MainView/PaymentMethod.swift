import SwiftUI

struct PaymentMethod: View {
    @Binding  var selectedMethod: String 
    
    var body: some View {
        VStack(spacing: 16) {
            PaymentCard(
                image: "paymob",
                title: "PayMob",
                subTitle: "Credit / Debit Card",
                isSelected: selectedMethod == "paymob"
            ) {
                selectedMethod = "paymob"
            }
            
            PaymentCard(
                image: "applePay",
                title: "Apple Pay",
                subTitle: "Touch ID or Face ID",
                isSelected: selectedMethod == "applePay"
            ) {
                selectedMethod = "applePay"
            }
        }
    }
    
    @ViewBuilder
    private func PaymentCard(image: String, title: String, subTitle: String, isSelected: Bool, onClick: @escaping () -> Void) -> some View {
        HStack(spacing: 16) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.size14Semibold)
                    .foregroundColor(.primaryNavy)
                Text(subTitle)
                    .font(.size12Medium)
                    .foregroundColor(.gray400)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(isSelected ? Color.clear : Color.gray200, lineWidth: 1.5)
                    .background(Circle().fill(isSelected ? Color.orange : Color.clear))
                    .frame(width: 28, height: 28)
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.r16)
                .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 1.5)
        )
        .onTapGesture {
            onClick()
        }
    }
}

//struct PaymentMethod_Previews: PreviewProvider {
//    static var previews: some View {
//        PaymentMethod()
//            .padding()
//            .background(Color.gray100)
//    }
//}
