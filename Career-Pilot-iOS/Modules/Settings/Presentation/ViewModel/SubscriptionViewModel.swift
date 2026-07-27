//
//  SubscriptionViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
import Combine

// SubscriptionViewModel.swift
@MainActor
final class SubscriptionViewModel: ObservableObject {
    @Published var plansState: LoadState<[SubscriptionPlan]> = .idle
    @Published var selectedPlan: PlanType = .free
    
    private let getPlansUseCase: GetSubscribtionPlan
    
    init(getPlansUseCase: GetSubscribtionPlan) {
        self.getPlansUseCase = getPlansUseCase
    }
    
    var currentPlan: SubscriptionPlan? {
        plansState.value?.first { $0.type == selectedPlan }
    }
    
    func loadPlans() async {
        plansState = .loading
        do {
            let plans = try await getPlansUseCase.execute()
            plansState = .success(plans)
        } catch {
            plansState = .failure(error)
        }
    }
}
