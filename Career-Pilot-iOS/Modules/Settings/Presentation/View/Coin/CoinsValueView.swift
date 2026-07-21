//
//  CoinsValueView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI
struct CoinsData: Identifiable {
    let id = UUID()
    let coinsValue: String
    let price: String
    let subTitle: String
}
struct CoinsValueView: View {
        @State private var selectedID: UUID? = nil
        
        let coinOptions = [
            CoinsData(coinsValue: "100", price: "29", subTitle: "Great for trying premium features"),
            CoinsData(coinsValue: "500", price: "119", subTitle: "Best value for regular practitioners"),
            CoinsData(coinsValue: "1,000", price: "199", subTitle: "Power users & intensive prep")
        ]

        var body: some View {
            VStack(spacing: 16) {
                ForEach(coinOptions) { option in
                    CoinsTypeVIew(
                        isClicked: Binding(
                            get: { selectedID == option.id },
                            set: { if $0 { selectedID = option.id } }
                        ),
                        price: option.price,
                        coinNumber: option.coinsValue,
                        subTitle: option.subTitle,
                        onTap: { selectedID = option.id }
                    ) .shadow(
                        color: selectedID == option.id ? Color.activeColour.opacity(0.08): Color.black.opacity(0.18),
                        radius: 12,
                        x: 0,
                        y: 4
                    )
                }
                
                Spacer()
                
                
                CustomButton(isButtonEnabeld: selectedID != nil, buttonTitle:  buttonLabel, onClick: {
                    
                })
                .disabled(selectedID == nil)
                .opacity(selectedID == nil ? 0.5 : 1.0)
            }
        }
        
        var buttonLabel: String {
            if let id = selectedID, let selected = coinOptions.first(where: { $0.id == id }) {
                return "Buy \(selected.coinsValue) Coins · EGP \(selected.price)"
            }
            return "Select a plan"
        }
    }

//
//struct CoinsValueView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoinsValueView()
//    }
//}
