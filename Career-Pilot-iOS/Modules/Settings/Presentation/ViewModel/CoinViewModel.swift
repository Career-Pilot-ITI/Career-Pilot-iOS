//
//  CoinViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
@MainActor
final class CoinViewModel: ObservableObject {
    @Published var packsState: LoadState<[CoinsPackViewData]> = .idle
    @Published var selectedID: UUID?
    
    private let getCoinPacksUseCase: GetCoinsPlans
    
    init(getCoinPacksUseCase: GetCoinsPlans) {
        self.getCoinPacksUseCase = getCoinPacksUseCase
    }
    
    func loadPacks() async {
        packsState = .loading
        do {
            let packs = try await getCoinPacksUseCase.execute().map{
                $0.toViewData()
            }
            packsState = .success(packs)
        } catch {
            packsState = .failure(error)
        }
    }
    
    var selectedPack: CoinsPackViewData? {
        packsState.value?.first { $0.id == selectedID }
    }
    
    var buttonLabel: String {
        guard let pack = selectedPack else { return "Select a plan" }
        return "Buy \(pack.coinsValue) Coins · EGP \(pack.price)"
    }
    
    func select(_ pack: CoinsPackViewData) {
        selectedID = pack.id
    }
}
