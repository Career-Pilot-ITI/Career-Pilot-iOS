//
//  CoinsValueView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//

import SwiftUI

struct CoinsValueView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var coordinator:  AppCoordinator<SettingsRoute>

      
    var body: some View {
           VStack(spacing: 16) {
               switch viewModel.packsState {
               case .idle, .loading:
                   ProgressView()
                   
               case .failure:
                   Text("Couldn't load coin packs")
                       .foregroundColor(.errorColour)
                   
               case .success(let packs):
                   ForEach(packs) { pack in
                       CoinsTypeVIew(
                           isClicked: Binding(
                               get: { viewModel.selectedID == pack.id },
                               set: { if $0 { viewModel.select(pack) } }
                           ),
                           price: pack.price,
                           coinNumber: pack.coinsValue,
                           subTitle: pack.subTitle,
                           onTap: { viewModel.select(pack) }
                       )
                       .shadow(
                           color: viewModel.selectedID == pack.id ? Color.activeColour.opacity(0.08) : Color.black.opacity(0.18),
                           radius: 12,
                           x: 0,
                           y: 4
                       )
                   }
               }
               
               Spacer()
               
               CustomButton(
                   isButtonEnabeld: viewModel.selectedID != nil,
                   buttonTitle: viewModel.buttonLabel,
                   onClick: {
                       guard let pack = viewModel.selectedPack else { return }
                       let item = CheckoutDisplayInfo.coinPack(
                           name: "\(pack.coinsValue) Coins",
                           pricePerPack: pack.price,
                           coinsIncluded: pack.coinsValue,
                           total: pack.price,
                           checkoutItem: .coinPack(packNumber: Int(pack.coinsValue)!)
                       )
                       coordinator.push(.checkout(item: item))
                   }
               )
               .disabled(viewModel.selectedID == nil)
               .opacity(viewModel.selectedID == nil ? 0.5 : 1.0)
           }
           .task {
               await viewModel.loadPacks()
           }
       }
    }

//
//struct CoinsValueView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoinsValueView()
//    }
//}
