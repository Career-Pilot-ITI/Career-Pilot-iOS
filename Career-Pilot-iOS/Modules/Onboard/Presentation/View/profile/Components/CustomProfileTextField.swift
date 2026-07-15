//
//  CustomProfileTextField.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/07/2026.
//
import SwiftUI
struct CustomProfileTextField: View {
    var icon : String
    let title: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    private var shouldFloat: Bool {
        isFocused || !text.isEmpty
    }
    var body: some View {
        HStack(spacing:12){
            customIcon(icon: icon)
            VStack(alignment: .leading, spacing: 4) {
                       if shouldFloat {
                           Text(title.uppercased())
                               .font(.caption.bold())
                               .foregroundColor(.gray600)
                           
                           TextField("", text: $text)
                               .font(.bodyAppSemiBold).foregroundColor(.primaryNavy)
                               .focused($isFocused)
                       } else {
                           TextField(title.uppercased(), text: $text)
                               .font(.bodyApp)
                               .foregroundColor(.gray400)
                               .focused($isFocused).frame(width: 210)
                       }
                       
                       Divider()
                    .frame(width: 210, height: 1)
                           .background(isFocused ? Color.activeColour : Color.gray400)
                   }
                   .animation(.easeOut(duration: 0.2), value: shouldFloat)
            
        }.padding(.vertical,Spacing.md)
    }
   @ViewBuilder
    private func customIcon(icon: String) -> some View {
        Image(icon)
            .foregroundColor(.primaryNavy)
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg )
                    .fill(Color.primaryNavy.opacity(0.06))
            )
    }
}

//struct CustomProfileTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomProfileTextField()
//    }
//}

